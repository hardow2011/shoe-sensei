class PagesController < ApplicationController
  include FilterPagination

  before_action only: %i[home filter_models] do
    set_filtered_models(false)
  end

  def home
  end

  def filter_models
  end
end
