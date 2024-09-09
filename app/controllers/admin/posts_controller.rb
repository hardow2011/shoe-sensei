class Admin::PostsController < Admin::AdminController
  before_action :set_post, only: %i[edit update destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      if @post.published
        notice = 'Post published successfuly'
      else
        notice = 'Post saved as draft successfuly'
      end
      redirect_to admin_posts_path, notice: notice
    else
      render :new, status: :unprocessed_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post.params)
      redirect_to admin_posts_path, 
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title_en, :title_es, :overview_en, :overview_es, :content_en, :content_es, tags: [])
  end
end
