class PagesController < ApplicationController
  include FilterPagination

  before_action :set_filtered_models, only: %i[home filter_models]

  def home
  end

  def filter_models
  end

  private

  def set_filtered_models
    brands_ids = params[:brand_ids]
    selected_activities = params[:activities]
    selected_cushionings = params[:cushionings]
    selected_supports = params[:supports]
    hide_brand_filter = params[:hide_brand_filter]

    models_filter = ModelsFilter.new(selected_activities, selected_cushionings, selected_supports, brands_ids, hide_brand_filter)
    @filter_list = models_filter.filter_list
    @models = models_filter.models
  end
end
