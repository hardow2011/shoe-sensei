# == Schema Information
#
# Table name: collections
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  overview   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  brand_id   :bigint           not null
#
# Indexes
#
#  index_collections_on_brand_id  (brand_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#
class Collection < ApplicationRecord
  belongs_to :brand
  has_many :models

  validates :name, :overview, presence: true
  validates :name, uniqueness: { scope: :brand }
  validates_presence_of :brand
end
