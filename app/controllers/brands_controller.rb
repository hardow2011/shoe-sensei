class BrandsController < ApplicationController
  include FilterPagination
  before_action :set_brand, only: %i[show]
  before_action only: %i[show] do
    set_filtered_models(nil, @brand.id)
  end

  def index
    @brands = Brand.order(:name)

    @meta_tags = {
      title: I18n.t('all_brands') + " | " + @app_name,
      description: I18n.t('list_of_all_brands')
    }
  end

  def show
    @meta_tags = {
      title: @brand.name + " | " + @app_name,
      description: I18n.t('brand_overview', brand_name: @brand.name)
    }
  end

  private

  def set_brand
    begin
      @brand = Brand.find_by_handle!(params[:id])
    rescue StandardError => e
      Sentry.capture_exception(e)
      Sentry.capture_message(e.message)
      redirect_to brands_path, notice: I18n.t('brand_not_found')
    end
  end
end
