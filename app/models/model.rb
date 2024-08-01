# == Schema Information
#
# Table name: models
#
#  id               :bigint           not null, primary key
#  apma_accepted    :boolean          not null
#  cached_tags      :json
#  discontinued     :boolean          default(FALSE)
#  heel_to_toe_drop :integer          not null
#  name             :string           not null
#  order            :integer          not null
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
  # Weight in grams.
  # Heel to toe drop in millimiters.
  belongs_to :collection
  has_one :brand, through: :collection

  ACTIVITY_OPTIONS = ['Road running', 'Trail running', 'Walking', 'Standing', 'Training and gym']
  CUSHIONING_OPTIONS = { 'Low': 1, 'Mid': 2, 'High': 3 }
  SUPPORT_OPTIONS = ['Neutral', 'Stability']

  validates :heel_to_toe_drop, :name, :weight, presence: true
  validates :name, uniqueness: { scope: :collection }
  validates :apma_accepted, :retired, inclusion: [ true, false ]
  validates :heel_to_toe_drop, numericality: { greater_than_or_equal_to: 0 }
  validates :weight, numericality: { greater_than_or_equal_to: 0.1 }
  validates_presence_of :collection

  validate :tags_validity

  acts_as_taggable_on :activity
  acts_as_taggable_on :cushioning
  acts_as_taggable_on :support

  def weight(to_oz = false)
    if to_oz
      (super() * 0.035274).round(2)
    else
      super()
    end
  end

  private
  def tags_validity
    self.activity_list.each do |tag|
      errors.add(:activity, "can't include #{tag}") if ACTIVITY_OPTIONS.exclude?(tag)
    end
    self.cushioning_list.each do |tag|
      errors.add(:cushioning, "can't include #{tag}") if CUSHIONING_OPTIONS.stringify_keys.keys.exclude?(tag)
    end
    self.support_list.each do |tag|
      errors.add(:support, "can't include #{tag}") if SUPPORT_OPTIONS.exclude?(tag)
    end
  end
end
