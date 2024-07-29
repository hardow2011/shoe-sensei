# == Schema Information
#
# Table name: models
#
#  id               :bigint           not null, primary key
#  apma_accepted    :boolean          not null
#  cushioning       :integer          not null
#  heel_to_toe_drop :integer          not null
#  iteration        :integer          not null
#  name             :string           not null
#  overview         :string           not null
#  stability        :boolean          not null
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
class Model < ApplicationRecord
  belongs_to :collection
  has_one :brand, through: :collection

  enum cushioning: [ :low_cushioning, :mid_cushioning, :high_cushioning ]

  validates :heel_to_toe_drop, :iteration, :name, :weight, :overview, presence: true
  validates :apma_accepted, :stability, inclusion: [ true, false ]
  validates :name, uniqueness: { scope: :collection }
  validates :iteration, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :heel_to_toe_drop, numericality: { greater_than_or_equal_to: 0 }
  validates :weight, numericality: { greater_than_or_equal_to: 0.1 }
  validates :iteration, uniqueness: { scope: :collection }
  validates :cushioning, inclusion: { in: cushionings.keys }
  validates_presence_of :collection
end
