class BrandsController < ApplicationController
  include FilterPagination
  before_action :set_brand, only: %i[show]

  def index
    @brands = Brand.order(:name)

    @meta_tags = {
      title: I18n.t('all_brands') + " | " + @app_name,
      description: I18n.t('list_of_all_brands')
    }
  end

  def show
    @models_count = @brand.models.only_still_in_production.count
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
      Rails.error.report(e, severity: :info)
      redirect_to brands_path, notice: I18n.t('brand_not_found')
    end
  end
end
