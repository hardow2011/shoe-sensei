# == Schema Information
#
# Table name: brands
#
#  id            :bigint           not null, primary key
#  company_color :string(7)        not null
#  handle        :string           not null
#  name          :string           not null
#  overview_en   :string           not null
#  overview_es   :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_brands_on_handle  (handle) UNIQUE
#  index_brands_on_name    (name) UNIQUE
#
class Brand < ApplicationRecord
  include DataFormatting
  extend Mobility
  translates :overview
  has_many :collections, dependent: :destroy
  has_many :models, through: :collections

  before_validation :assign_handle

  after_save :renew_models_cache

  validates :name, :handle, :company_color, :overview_en, :overview_es, presence: true
  validates :company_color, length: { is: 7 }, format: { with:   /\#?([a-f0-9]{6}|[a-f0-9]{3})\z/,message: "only allows letters" }
  validates :name, :handle, uniqueness: true
  validates :handle, format: { with: DataFormatting::HANDLE_FORMAT }

  has_one_attached :logo do |attachable|
    attachable.variant :thumb, resize_to_limit: [500, 500], preprocessed: true
  end

  validates :logo, attached: true, content_type: ['image/png', 'image/webp', 'image/jpeg', 'image/jpg'],
                  size: { less_than_or_equal_to: 2.megabytes }

  private

  def renew_models_cache
    models.touch_all
  end
end
