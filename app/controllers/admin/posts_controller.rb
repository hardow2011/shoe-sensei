class Admin::PostsController < Admin::AdminController
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = Post.order(updated_at: :desc)
  end

  def new
    @post = Post.new(published_at: Date.current)
  end

  def create
    @post = Post.new(post_params)

    @post.published = get_published_value_from_params
    @post.images_ids = get_images_to_attach

    if @post.save
      redirect_to admin_posts_path, notice: notice_message_from_published_status(@post)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @post.published = get_published_value_from_params
    @post.images_ids = get_images_to_attach

    if @post.update(post_params)
      redirect_to admin_posts_path, notice: notice_message_from_published_status(@post)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: 'Post was destroyed successfully.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  # Get the signed ids from the uploaded images redirect signed ids
  # <img src="...rails/active_storage/blobs/redirect/<signed_id>/..."
  def get_images_to_attach(*strings_to_scan)
    images_to_attach = []
    images_to_attach += post_params[:content_en].scan(/rails\/active_storage\/blobs\/redirect\/(.+?)\//).flatten.uniq
    images_to_attach += post_params[:content_es].scan(/rails\/active_storage\/blobs\/redirect\/(.+?)\//).flatten.uniq

    images_to_attach
  end

  def post_params
    params.require(:post).permit(:title_en, :title_es, :overview_en, :overview_es, :has_affiliate_links, :content_en, :content_es, :published_at, tags: [])
  end

  def get_published_value_from_params
    if [t('save_as_draft'), t('unpublish_post_and_save_as_draft')].include?(params[:commit])
      return false
    elsif [t('publish_post'), t('publish_updates')].include?(params[:commit])
      return true
    else
      Rails.error.report("Commit value #{params[:commit]} not allowed")
      render :new, status: :unprocessable_entity
      return
    end
  end

  def notice_message_from_published_status(post)
    if post.published
      return 'Post published successfuly.'
    else
      return 'Post saved as draft successfuly.'
    end
  end
end
