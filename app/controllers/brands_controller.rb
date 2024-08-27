class BrandsController < ApplicationController
  include FilterPagination
  before_action :set_brand, only: %i[show]
  before_action only: %i[show] do
    set_filtered_models(true, [@brand.id])
  end

  def show
  end

  private

  def set_brand
    @brand = Brand.find_by_handle(params[:id])
  end
end
