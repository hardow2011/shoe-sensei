# == Schema Information
#
# Table name: posts
#
#  id                   :bigint           not null, primary key
#  content_en           :string           not null
#  content_es           :string           not null
#  handle               :string
#  has_affiliate_links  :boolean          default(FALSE)
#  overview_en          :string           not null
#  overview_es          :string           not null
#  published            :boolean          not null
#  published_at         :date             default(Mon, 07 Oct 2024)
#  table_of_contents_en :jsonb            not null
#  table_of_contents_es :jsonb            not null
#  tags                 :string           default([]), not null, is an Array
#  title_en             :string           not null
#  title_es             :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_posts_on_handle  (handle) UNIQUE
#
class Post < ApplicationRecord
  include DataFormatting
  include AllowedTags
  extend Mobility

  # serialize :table_of_contents_en, coder: HashSerializer
  # serialize :table_of_contents_es, coder: HashSerializer

  # TODO: update tests to use tinymce
  has_many_attached :images

  translates :overview
  translates :title
  translates :table_of_contents
  translates :content

  before_validation :assign_blank_if_null

  validates :title_en, :title_es, presence: true
  validates :published, :has_affiliate_links, inclusion: { in: AllowedTags::BOOLEAN_OPTIONS }
  validates :title_en, :title_es, uniqueness: true
  validate :tags_validity
  validate :table_of_contents_validity

  before_save :sanitize_content

  before_validation :assign_table_of_contents
  # Only run the following valiations if the post is published
  with_options if: -> { published } do
    validates :content_en, :content_es, :overview_en, :overview_es, :handle, :tags, :published_at, presence: true
    validates :handle, format: { with: DataFormatting::HANDLE_FORMAT }
    validates :handle, uniqueness: true
    before_validation :assign_handle
  end

  after_validation :update_images_attachments

  attr_accessor :images_ids

  has_many :comments

  scope :published, -> { where(published: true) }

  def humanized_published_at
    self.published_at.present? ? I18n.l(self.published_at, format: :long) : nil
  end

  def destroy
    Comment.where(post_id: self.id).delete_all
    super
  end

  private

  def update_images_attachments
    # uniq here to prevent index unique constraint problem on copy and pasting images from tinymce
    self.images = images_ids&.uniq
  end

  def tags_validity
    forbidden_tags = self.tags - AllowedTags::POSTS_OPTIONS
    if forbidden_tags.any?
      errors.add(:tags, "#{forbidden_tags} tags not allowed")
    end
  end

  def table_of_contents_columns
    ['table_of_contents_en', 'table_of_contents_es']
  end

  def table_of_contents_validity
    necessary_keys = [:tag, :title, :id]

    table_of_contents_columns.each do |table_of_contents_column|
      unless self[table_of_contents_column.to_sym].is_a?(Array)
        errors.add(table_of_contents_column.to_sym, "Table of contents must be an Array")
      else
        self[table_of_contents_column.to_sym].each do |tag|
          unless tag.is_a?(Hash)
            errors.add(table_of_contents_column.to_sym, "#{tag} must be a Hash")
          else
            necessary_keys.each do |key|
              tag.has_key?(key) ? nil : errors.add(table_of_contents_column.to_sym, "#{tag} must have #{key} key")
            end
          end
        end
      end
    end
  end

  def assign_table_of_contents
    table_of_contents_columns.each do |table_of_contents_column|
      # Set tables of contents to nil
      self[table_of_contents_column.to_sym] = []
      # Get associated content columns.
      content_column =
        if table_of_contents_column == 'table_of_contents_en'
          'content_en'
        elsif table_of_contents_column == 'table_of_contents_es'
          'content_es'
        end
      doc_content = Nokogiri::HTML(self[content_column.to_sym])

      if self[content_column.to_sym].present?
        # Get all h2 and h3 tags
        tags = doc_content.css('h2,h3')
        # Loop through the tags
        tags.each_with_index do |tag, i|
          # Tag name
          name = tag.name
          # Skip iteration of tag not h2
          next if name != 'h2'
          # Tag content
          content = tag.content
          # Tag id
          id = content.parameterize
          tag['id'] = id
          tag = {tag: name, title: content, id: id }
          # Start looking fot next h3 tags
          h3_tag_index = i+1
          while tags[h3_tag_index] && tags[h3_tag_index].name == 'h3'
            h3_name = tags[h3_tag_index].name
            h3_content = tags[h3_tag_index].content
            h3_id = h3_content.parameterize
            # Assign tag[:nested_tags] to empty array of it did not exist
            tag[:nested_tags].nil? ? tag[:nested_tags] = [] : nil
            # Assign the h3 tags in the nested_tags attributes inside the h2 tag
            tag[:nested_tags] << {tag: h3_name, title: h3_content, id: h3_id }
            h3_tag_index += 1
          end
          # Append tag to list of tags
          self[table_of_contents_column.to_sym] << tag
        end
        # overwrite the content column to include the ids set with nokogiri
        self[content_column.to_sym] = doc_content.at('body').inner_html
      end
    end
  end

  def assign_handle
    # self.published && !self.handle -- if the first time gettin published
    # self.title_en_changed? -- if the title changed
    # self.title_en -- only chec for the other conditions if the title exists to begin with
    if self.title_en && ((self.published && !self.handle) || self.title_en_changed?)
      # .parameterize[0..50] get first 50 chars of parameterized title
      self.handle = self.title_en.parameterize[0..50]

      # If the handle is longer than 50 chars, remove the last words
      # .split('-') create array by separating by minus sign
      # [..-2] take out last element
      # .join('-') rejoin the array by separating by minus sign
      while self.handle.length > 50
        self.handle = self.handle.split('-')[..-2].join('-')
      end

      if Post.find_by(handle: self.handle).present?
        # self.handle = self.handle + '-' + index.to_s
        original_handle = self.handle.dup
        handle_index = 2

        while Post.find_by(handle: self.handle).present? do
          self.handle = original_handle + '-' + handle_index.to_s
          handle_index += 1
        end
      end
    end
  end

  def sanitize_content
    self.content_en = content_en.to_s.gsub(/<h1>/, '<h2>').gsub(/<\/h1>/, '</h2>')
    self.content_es = content_es.to_s.gsub(/<h1>/, '<h2>').gsub(/<\/h1>/, '</h2>')
  end

  # TODO: remove this nonsense and allow nil instead
  def assign_blank_if_null
    # Leave handle as nil until post published.
    # Then, assign handle with assign_handle method
    # self.handle = '' unless self.handle
    self.content_en = '' unless self.content_en
    self.content_es = '' unless self.content_es
    self.overview_en = '' unless self.overview_en
    self.overview_es = '' unless self.overview_es
  end
end
