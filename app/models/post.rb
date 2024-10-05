# == Schema Information
#
# Table name: posts
#
#  id                   :bigint           not null, primary key
#  content_en           :string           not null
#  content_es           :string           not null
#  handle               :string
#  overview_en          :string           not null
#  overview_es          :string           not null
#  published            :boolean          not null
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

  before_validation :assign_blank_if_null

  validates :title_en, :title_es, presence: true
  validates :published, inclusion: { in: AllowedTags::BOOLEAN_OPTIONS }
  validates :title_en, :title_es, uniqueness: true
  validate :tags_validity
  validate :table_of_contents_validity

  before_save :sanitize_content

  before_validation :assign_table_of_contents
  # Only run the following valiations if the post is published
  with_options if: -> { published } do
    validates :content_en, :content_es, :overview_en, :overview_es, :handle, :tags, presence: true
    validates :handle, format: { with: DataFormatting::HANDLE_FORMAT }
    validates :handle, uniqueness: true
    before_validation :assign_handle
  end

  after_validation :update_images_attachments

  attr_accessor :images_ids

  scope :published, -> { where(published: true) }

  def content
    self.send("content_#{I18n.locale.to_s}")
  end

  private

  def update_images_attachments
    self.images = images_ids
  end

  def tags_validity
    forbidden_tags = self.tags - AllowedTags::POSTS_OPTIONS
    if forbidden_tags.any?
      errors.add(:tags, "#{forbidden_tags} tags not allowed")
    end
  end

  def table_of_contents_validity
    necessary_keys = [:tag, :title, :id]
    table_of_contents_columns = ['table_of_contents_en', 'table_of_contents_es']

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
    self.table_of_contents_en = []
    doc_content_en = Nokogiri::HTML(self.content_en)

    self.table_of_contents_es = []
    doc_content_es = Nokogiri::HTML(self.content_es)

    if self.content_en.present?
      doc_content_en.css('h2,h3').each do |tag|
        id = tag.content.parameterize
        tag['id'] = id
        self.table_of_contents_en << {tag: tag.name, title: tag.content, id: id }
      end

      self.content_en = doc_content_en.at('body').inner_html
    end

    if self.content_es.present?
      doc_content_es.css('h2,h3').each do |tag|
        id = tag.content.parameterize
        tag['id'] = id
        self.table_of_contents_es << {tag: tag.name, title: tag.content, id: id }
      end

      self.content_es = doc_content_es.at('body').inner_html
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
