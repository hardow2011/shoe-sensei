class Admin::ArticlesController < Admin::AdminController
  # before_action :set_article, only: %i[edit update destroy]

  def new
    @article = Article.new
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content_en, :content_es, tags: [])
  end
end
