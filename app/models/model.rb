# == Schema Information
#
# Table name: models
#
#  id               :bigint           not null, primary key
#  handle           :string           not null
#  heel_to_toe_drop :integer          not null
#  name             :string           not null
#  tags             :jsonb            not null
#  weight           :float            not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  collection_id    :bigint           not null
#
# Indexes
#
#  index_models_on_collection_id           (collection_id)
#  index_models_on_name_and_collection_id  (name,collection_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (collection_id => collections.id)
#
class Model < ApplicationRecord
  include DataFormatting
  include AllowedTags
  # Weight in grams.
  # Heel to toe drop in millimiters.
  belongs_to :collection
  has_one :brand, through: :collection

  has_one_attached :image

  serialize :tags, coder: HashSerializer

  validates :handle, format: { with: DataFormatting::HANDLE_FORMAT }
  validates :heel_to_toe_drop, :name, :weight, presence: true
  validates :name, :handle, uniqueness: { scope: :collection, case_sensitive: false }
  validates :heel_to_toe_drop, numericality: { greater_than_or_equal_to: 0 }
  validates :weight, numericality: { greater_than_or_equal_to: 0.1 }
  validates_presence_of :collection
  validates :image, attached: true, content_type: ['image/webp'],
                    size: { less_than_or_equal_to: 250.kilobytes }

  before_validation :assign_handle

  validate :tags_validity

  scope :order_by_cushioning_level, ->(order = :asc) { order(Arel.sql("tags ->> 'cushioning_level' #{ order == :desc ? 'DESC' : 'ASC' }, name")) }
  scope :order_by_weight, ->(order = :asc) { order(weight: order) }
  scope :order_by_heel_to_toe_drop, ->(order = :asc) { order(heel_to_toe_drop: order) }
  scope :discontinued, ->(discontinued = true) { where("tags ->> 'discontinued' = '#{discontinued}'") }

  # Filter for tags
  scope :only_still_in_production, ->(discontinued = true) { where("tags ->> 'discontinued' = '#{!discontinued}'") if discontinued }
  scope :filter_by_activities, ->(activities_list) { where("tags -> 'activities' ?| array#{activities_list.to_s.gsub('"',"'")}") if activities_list.any? }
  scope :filter_by_supports, ->(supports_list) { where("tags -> 'support' ?| array#{supports_list.to_s.gsub('"',"'")}")  if supports_list.any? }
  scope :filter_by_cushioning_levels, ->(cushioning_levels_list) { where("tags -> 'cushioning_level' <@ '#{cushioning_levels_list}'::jsonb") if cushioning_levels_list.any? }
  scope :filter_by_apma_accepted, ->(apma_accepted) { where("tags ->> 'apma_accepted' = '#{apma_accepted}'") if apma_accepted.present? }
  scope :filter_by_brand_ids, ->(brands_ids) { joins(:brand).where(brand: { id: brands_ids }) if brands_ids.any? }

  # scope :tagged_with_high_cushioning, -> { where("tags -> 'cushioning' ? 'High'") }
  # scope :tagged_with_mid_cushioning, -> { where("tags -> 'cushioning' ? 'Mid'") }
  # scope :tagged_with_low_cushioning, -> { where("tags -> 'cushioning' ? 'Low'") }
  # scope :tagged_with_stability_support, -> { where("tags -> 'support' ? 'Stability'") }
  # scope :tagged_with_neutral_support, -> { where("tags -> 'support' ? 'Neutral'") }

  def weight(to_oz = false)
    if to_oz
      (super() * 0.035274).round(2)
    else
      super()
    end
  end

  def cushioning_name
    AllowedTags::CUSHIONING_OPTIONS[self.tags[:cushioning_level] - 1]
  end

  private
  def tags_validity
    if tags[:activities].nil?
      errors.add(:activities, "must exist")
    elsif !tags[:activities].is_a?(Array)
      errors.add(:activities, "must be list of allowed activities")
    else
      self.tags[:activities].each do |tag|
        errors.add(:activities, "can't include #{tag}") if AllowedTags::ACTIVITY_OPTIONS.exclude?(tag)
      end
    end

    if tags[:cushioning_level].nil?
      errors.add(:cushioning_level, "must exist")
    elsif !tags[:cushioning_level].is_a? Integer
      errors.add(:cushioning_level, "must be an Integer")
    elsif !tags[:cushioning_level].between?(1, AllowedTags::CUSHIONING_OPTIONS.size)
      errors.add(:cushioning_level, "must be between 1 and #{AllowedTags::CUSHIONING_OPTIONS.size}")
    end

    if tags[:support].nil?
      errors.add(:support, "must exist")
    else
      errors.add(:support, "can't be #{self.tags[:support]}") if AllowedTags::SUPPORT_OPTIONS.exclude?(self.tags[:support])
    end

    if tags[:apma_accepted].nil?
      errors.add(:apma_accepted, "must exist")
    else
      errors.add(:apma_accepted, "must be either true or false") if AllowedTags::BOOLEAN_OPTIONS.exclude?(self.tags[:apma_accepted])
    end

    if tags[:discontinued].nil?
      errors.add(:discontinued, "must exist")
    else
      errors.add(:discontinued, "must be either true or false") if AllowedTags::BOOLEAN_OPTIONS.exclude?(self.tags[:discontinued])
    end
  end
end
