class Admin::CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection, only: %i[show edit update destroy]
  layout 'admin'

  def index
    if params[:brand_id]
      # TODO: add failsafe if brand not valid
      brand = Brand.get_by_handle(params[:brand_id])
      @collections = brand.collections
    else
      @collections = Collection.order(created_at: :desc)
    end
  end

  def show

  end

  def new
    @collection = Collection.new
    @collection.brand = Brand.find(params[:brand_id]) if params[:brand_id]
  end

  def create
    @collection = Collection.new(collection_params)

    if @collection.save
      respond_to do |format|
        format.html { redirect_to admin_collections_path, notice: 'Collection was created successfully.' }
        format.turbo_stream do
          flash.now[:notice] = 'Collection was created successfully.'
          @collections = Collection.where(brand: @collection.brand).order(:name)
        end
      end
      else
        render :new, status: :unprocessable_entity
    end
  end

  def edit

  end

  def update
    if @collection.update(collection_params)
      redirect_to admin_collections_path, notice: 'Collection was updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to admin_collections_path, notice: 'Collection was destroyed successfully.' }
      format.turbo_stream do
        flash.now[:notice] = 'Collection was destroyed successfully.'
        @collections = Collection.where(brand: @collection.brand).order(:name)
      end
    end
  end

  private

  def collection_params
    params.require(:collection).permit(:name, :overview, :brand_id)
  end

  def set_collection
    @collection = Collection.find(params[:id])
  end

end
