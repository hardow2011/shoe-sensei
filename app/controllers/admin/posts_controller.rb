class Admin::PostsController < Admin::AdminController
  # before_action :set_post, only: %i[edit update destroy]

  def new
    @post = Post.new
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content_en, :content_es, tags: [])
  end
end
