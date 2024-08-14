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
    @collection.brand_id = params[:brand_id] if params[:brand_id]
  end

  def create
    @collection = Collection.new(collection_params)

    if @collection.save
      redirect_to admin_collections_path, notice: 'Collection was created successfully.'
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
    redirect_to admin_collections_path, notice: 'Collection was destroyed successfully.'
  end

  private

  def collection_params
    params.require(:collection).permit(:name, :overview, :brand_id)
  end

  def set_collection
    @collection = Collection.get_by_handle(params[:id])
  end

end
