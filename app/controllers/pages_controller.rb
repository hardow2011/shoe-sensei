class PagesController < ApplicationController
  include FilterPagination

  def home
    @models_count = Model.only_still_in_production.count
  end

  def filter_models
    set_filtered_models(nil, params[:brand_id] || nil)
  end

  def privacy_policy
    render "pages/policies/privacy_#{locale}"
  end

  def terms_of_use
    render "pages/policies/terms_#{locale}"
  end
end
