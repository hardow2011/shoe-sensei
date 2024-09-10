class PostsController < ApplicationController
  before_action :set_brand, only: %i[show]

  def index
    @posts = Post.published.order(created_at: :desc)
  end

  def show
  end

  private

  def set_brand
    begin
      @post = Post.find_by_handle!(params[:id])
    rescue StandardError => e
      Sentry.capture_exception(e)
      Sentry.capture_message(e.message)
      redirect_to posts_path, notice: I18n.t('post_not_found')
    end
  end

end
