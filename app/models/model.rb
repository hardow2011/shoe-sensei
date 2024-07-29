# == Schema Information
#
# Table name: models
#
#  id               :bigint           not null, primary key
#  apma_accepted    :boolean          not null
#  heel_to_toe_drop :integer          not null
#  iteration        :integer          not null
#  name             :string           not null
#  overview         :string           not null
#  weight           :integer          not null
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
# TODO: add activity_list, cushioning_list and support_list to controller
class Model < ApplicationRecord
  belongs_to :collection
  has_one :brand, through: :collection

  ACTIVITY_OPTIONS = ['running', 'walking', 'standing', 'training and gym']
  CUSHIONING_OPTIONS = ['low', 'mid', 'high']
  SUPPORT_OPTIONS = ['neutral', 'stability']

  validates :heel_to_toe_drop, :iteration, :name, :weight, :overview, presence: true
  validates :apma_accepted, inclusion: [ true, false ]
  validates :name, uniqueness: { scope: :collection }
  validates :iteration, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :heel_to_toe_drop, numericality: { greater_than_or_equal_to: 0 }
  validates :weight, numericality: { greater_than_or_equal_to: 0.1 }
  validates :iteration, uniqueness: { scope: :collection }
  validates_presence_of :collection

  validate :tags_validity

  acts_as_taggable_on :activity
  acts_as_taggable_on :cushioning
  acts_as_taggable_on :support

  private
  def tags_validity
    self.activity_list.each do |tag|
      errors.add(:activity, "can't include #{tag}") if ACTIVITY_OPTIONS.exclude?(tag)
    end
    self.cushioning_list.each do |tag|
      errors.add(:cushioning, "can't include #{tag}") if CUSHIONING_OPTIONS.exclude?(tag)
    end
    self.support_list.each do |tag|
      errors.add(:support, "can't include #{tag}") if SUPPORT_OPTIONS.exclude?(tag)
    end
  end

end
