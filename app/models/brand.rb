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
class Brand < ApplicationRecord
  has_many :collections
  has_many :models, through: :collections
  validates :name, :handle, :overview, presence: true
  validates :name, :handle, uniqueness: true
  validates :handle, format: { with: /[a-zA-Z0-9-]+/ }

  before_validation :assign_handle

  def to_param
    handle
  end

  def self.get_by_handle(handle)
    Brand.find_sole_by(handle: handle)
  end

  private

  def assign_handle
    if self.name && self.name_changed?
      self.handle = self.name.parameterize
    end
  end
end
