# == Schema Information
#
# Table name: models
#
#  id               :bigint           not null, primary key
#  apma_accepted    :boolean          not null
#  discontinued     :boolean          default(FALSE)
#  heel_to_toe_drop :integer          not null
#  name             :string           not null
#  order            :integer          not null
#  tags             :jsonb            not null
#  weight           :float            not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  collection_id    :bigint           not null
#
# Indexes
#
#  index_models_on_collection_id  (collection_id)
#
# Foreign Keys
#
#  fk_rails_...  (collection_id => collections.id)
#
class Model < ApplicationRecord
  include AllowedTags
  # Weight in grams.
  # Heel to toe drop in millimiters.
  belongs_to :collection
  has_one :brand, through: :collection

  serialize :tags, coder: HashSerializer

  validates :heel_to_toe_drop, :name, :weight, presence: true
  validates :name, uniqueness: { scope: :collection }
  validates :apma_accepted, :discontinued, inclusion: [ true, false ]
  validates :heel_to_toe_drop, numericality: { greater_than_or_equal_to: 0 }
  validates :weight, numericality: { greater_than_or_equal_to: 0.1 }
  validates :cushioning, numericality: { in: 0..(AllowedTags::CUSHIONING_OPTIONS.size-1) }
  validates :support, inclusion: { in: AllowedTags::SUPPORT_OPTIONS }
  validates_presence_of :collection

  validate :tags_validity

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

  def cushioning_level
    AllowedTags::CUSHIONING_OPTIONS.find_index(self.tags[:cushioning])
  end

  private
  def tags_validity
    if tags[:activities].nil?
      errors.add("Activity list", "must exist")
      else
        errors.add("Activity list", "must have at least one type") if self.tags[:activities].size < 1
        self.tags[:activities].each do |tag|
          errors.add("Activity list", "can't include #{tag}") if AllowedTags::ACTIVITY_OPTIONS.exclude?(tag)
        end
    end

    if tags[:cushioning].nil?
      errors.add("Cushioning", "must exist")
    else
      errors.add("Cushioning", "can't include #{self.tags[:cushioning]}") if AllowedTags::CUSHIONING_OPTIONS.exclude?(self.tags[:cushioning])
    end

    if tags[:support].nil?
      errors.add("Support", "must exist")
    else
      errors.add("Support", "can't include #{self.tags[:support]}") if AllowedTags::SUPPORT_OPTIONS.exclude?(self.tags[:support])
    end
  end
end
