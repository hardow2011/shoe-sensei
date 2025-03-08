class Admin::ModelsController < Admin::AdminController
  before_action :set_model, only: %i[edit update destroy]

  def index
    @models = models_by_default_order
  end

  def new
    @model = Model.new
    @model.collection = Collection.find(params[:collection_id]) if params[:collection_id]
  end

  def create
    @model = Model.new(model_params)
    format_model_tags

    if @model.save
      respond_to do |format|
        format.html { redirect_to admin_models_path, notice: 'Model was created successfully.' }
        format.turbo_stream do
          flash.now[:notice] = 'Model was created successfully.'
          @models = Model.where(collection: @model.collection).order(:name)
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit

  end

  def update
    @model.assign_attributes(model_params)
    format_model_tags
    if @model.save
      redirect_to admin_models_path, notice: 'Model was updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @model.destroy
    # If the request comes from the collections index page, then
    # repopulate with all collection after deletion
    if request.params["deleted_from_index"] == "true"
      models = models_by_default_order
    # Otherwise, the collection deletion request comes from the brand page
    # Then, return only the collection belonging to that brand 
    else
      models = Model.where(collection: @model.collection).order(:name)
    end
    respond_to do |format|
      format.html { redirect_to admin_models_path, notice: 'Model was destroyed successfully.' }
      format.turbo_stream do
        flash.now[:notice] = 'Model was destroyed successfully.'
        unless request.params["deleted_from_index"] == "true"
          @collection = @model.collection
        end
      end
    end
  end

  private

  def set_model
    @model = Model.find(params[:id])
  end

  def format_model_tags
    if @model.tags[:cushioning_level]
      @model.tags[:cushioning_level] = Integer(@model.tags[:cushioning_level])
    end

    @model.tags[:apma_accepted] = ActiveModel::Type::Boolean.new.cast(@model.tags[:apma_accepted])

    @model.tags[:discontinued] = ActiveModel::Type::Boolean.new.cast(@model.tags[:discontinued])
  end

  def model_params
    params.require(:model).permit(:name, :image, :heel_to_toe_drop, :weight, :collection_id, tags: [:cushioning_level, :support, :apma_accepted, :discontinued, activities: []])
  end

  def models_by_default_order
    Model.order(updated_at: :desc)
  end
end
