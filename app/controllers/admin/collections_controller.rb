class Admin::CollectionsController < Admin::AdminController
  before_action :set_collection, only: %i[show edit update destroy]

  def index
    brand = Brand.get_by_handle(params[:brand_id])
    if brand
      @collections = brand.collections if brand
      return
    end
    @collections = collections_by_default_order
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
    # If the request comes from the collections index page, then
    # repopulate with all collection after deletion
    if request.params["deleted_from_index"] == "true"
      collections = collections_by_default_order
    # Otherwise, the collection deletion request comes from the brand page
    # Then, return only the collection belonging to that brand 
    else
      collections = Collection.where(brand: @collection.brand).order(:name)
    end
    respond_to do |format|
      format.html { redirect_to admin_collections_path, notice: 'Collection was destroyed successfully.' }
      format.turbo_stream do
        flash.now[:notice] = 'Collection was destroyed successfully.'
        @collections = collections
        unless request.params["deleted_from_index"] == "true"
          @brand = @collection.brand
        end
      end
    end
  end

  private

  def collection_params
    params.require(:collection).permit(:name, :overview_en, :overview_es, :brand_id)
  end

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collections_by_default_order
    Collection.order(created_at: :desc)
  end

end
