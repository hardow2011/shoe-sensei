class PagesController < ApplicationController
  def home
    @models = Model.all
  end

  def filter_models
    brands_ids = []
    params[:brand].each do |brand_name|
      brands_ids << Brand.find_by(name: brand_name).id
    end
    activity = params[:activity]
    cushioning = params[:cushioning]
    support = params[:support]


    @models = Model.joins(:brand).where(brand: { id: brands_ids })
    @models = @models.tagged_with(activity, on: :activity, any: true) if activity
    @models = @models.tagged_with(cushioning, on: :cushioning, any: true) if cushioning
    @models = @models.tagged_with(support, on: :support, any: true) if support
  end
end
