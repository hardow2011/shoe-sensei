# == Schema Information
#
# Table name: collections
#
#  id         :bigint           not null, primary key
#  handle     :string           not null
#  name       :string           not null
#  overview   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  brand_id   :bigint           not null
#
# Indexes
#
#  index_collections_on_brand_id             (brand_id)
#  index_collections_on_handle_and_brand_id  (handle,brand_id) UNIQUE
#  index_collections_on_name_and_brand_id    (name,brand_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#
class Collection < ApplicationRecord
  include DataFormatting
  belongs_to :brand
  has_many :models, dependent: :destroy

  validates :name, :overview, :handle, presence: true
  validates :name, :handle, uniqueness: { scope: :brand, case_sensitive: false }
  validates :handle, format: { with: DataFormatting::HANDLE_FORMAT }
  validates_presence_of :brand

  before_validation :assign_handle

  def to_param
    handle
  end
end
