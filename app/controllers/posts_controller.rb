class PostsController < ApplicationController
  before_action :set_post, only: %i[show]

  def index
    @posts = Post.published.order(created_at: :desc)
    @meta_tags = {
      title: t('blog_title', app_name: @app_name),
      description: t('blog_description', app_name: @app_name)
    }
  end

  def show
    @meta_tags = {
      title: t('blog_post_meta_title', title: @post.title, app_name: @app_name),
      description: @post.overview
    }
  end

  private

  def set_post
    begin
      @post = Post.find_by_handle!(params[:id])
    rescue StandardError => e
      Rails.error.report(e, severity: :info)
      redirect_to posts_path, notice: I18n.t('post_not_found')
    end
  end

end
