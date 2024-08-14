# == Schema Information
#
# Table name: brands
#
#  id         :bigint           not null, primary key
#  handle     :string           not null
#  name       :string           not null
#  overview   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_brands_on_handle  (handle) UNIQUE
#  index_brands_on_name    (name) UNIQUE
#
class Brand < ApplicationRecord
  include DataFormatting
  has_many :collections, dependent: :destroy
  has_many :models, through: :collections

  before_validation :assign_handle

  validates :name, :handle, :overview, presence: true
  validates :name, :handle, uniqueness: true
  validates :handle, format: { with: DataFormatting::HANDLE_FORMAT }


  def to_param
    handle
  end
end
