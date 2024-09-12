class PagesController < ApplicationController
  include FilterPagination

  def home
    @models_count = Model.only_still_in_production.count
  end

  def filter_models
    set_filtered_models(nil, params[:brand_id] || nil)
  end
end
