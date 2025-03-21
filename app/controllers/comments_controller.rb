class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show]
  
  def index
      post_id = params[:post_id]
      @comments = Comment.top_comments.where(post_id: post_id).order(created_at: :desc)
  end
  
  def show
  end

  def replies
    @comment = Comment.find(params[:comment_id])
    @replies = @comment.replies
  end

  def new
      post_id = params[:post_id]
      parent_comment = params[:comment_id]
      @comment = Comment.new(post_id: post_id, user_id: user_signed_in? ? current_user.id : nil, comment_id: parent_comment)
  end
  
  def create
      comment = Comment.new(comment_params)
      if comment.save
          respond_to do |format|
            format.html { redirect_to post_comments_path, notice: 'Comment posted successfully.' }
            format.turbo_stream do
              flash.now[:notice] = 'Comment posted successfully.'
              @comments = Comment.top_comments.where(post_id: comment.post_id).order(created_at: :desc)
              @new_comment = Comment.new(post_id: comment.post_id)
              @turbo_frame_id_to_update = comment_turbo_redirect_params
              @comment = comment
              # byebug
            end
          end
        else
          render :new, status: :unprocessable_entity
        end
  end

  private

  def comment_params
      params.require(:comment).permit(:content, :post_id, :user_id, :comment_id)
  end

  def comment_turbo_redirect_params
    params.require(:turbo_frame_id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end