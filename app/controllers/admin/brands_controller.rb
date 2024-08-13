class Admin::BrandsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_brand, only: %i[edit update destroy]

  layout 'admin'

  def index
    @brands = Brand.order(created_at: :desc)
  end

  def show

  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)

    if @brand.save
      redirect_to admin_brands_path, notice: 'Brand was created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit

  end

  def update
    if @brand.update(brand_params)
      redirect_to admin_brands_path, notice: 'Brand was updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @brand.destroy
    redirect_to admin_brands_path, notice: 'Brand was destroyed successfully.'
  end

  private

  def brand_params
    params.require(:brand).permit(:name, :overview)
  end

  def set_brand
    @brand = Brand.get_by_handle(params[:id])
  end

end
