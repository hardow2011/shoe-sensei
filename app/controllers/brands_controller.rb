class BrandsController < ApplicationController
  include FilterPagination
  before_action :set_brand, only: %i[show]
  before_action only: %i[show] do
    set_filtered_models(true, [@brand.id])
  end

  def show
    # brands_ids = [@brand.id]
    # selected_activities = params[:activities]
    # selected_cushionings = params[:cushionings]
    # selected_supports = params[:supports]

    # @models = @brand.models

    # models_filter = ModelsFilter.new(selected_activities, selected_cushionings, selected_supports, brands_ids, true)
    # @filter_list = models_filter.filter_list
    # @models = models_filter.models
  end

  private

  def set_brand
    @brand = Brand.find_by_handle(params[:id])
  end
end
