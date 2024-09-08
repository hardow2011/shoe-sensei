# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  handle     :string           not null
#  published  :boolean          not null
#  tags       :string           default([]), not null, is an Array
#  title_en   :string           not null
#  title_es   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_articles_on_handle  (handle) UNIQUE
#
class Article < ApplicationRecord
  include DataFormatting
  include AllowedTags
  extend Mobility

  # TODO: validate presence of content
  has_rich_text :content_en
  has_rich_text :content_es
  translates :content
  translates :title

  validates :title_en, :title_es, :handle, :tags, presence: true
  validates :handle, format: { with: DataFormatting::HANDLE_FORMAT }
  validates :published, inclusion: { in: AllowedTags::BOOLEAN_OPTIONS }
  validates :name, :handle, :title_en, :title_es, uniqueness: true

  validate :tags_validity

  private

  def tags_validity
    allowed_tags = AllowedTags::ACTIVITY_OPTIONS + AllowedTags::SUPPORT_OPTIONS
    forbidden_tags = self.tags - allowed_tags
    if forbidden_tags.any?
      errors.add(:tags, "#{forbidden_tags} tags not allowed")
    end
  end
end
