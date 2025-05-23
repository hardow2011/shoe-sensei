class CommentsController < ApplicationController
  before_action :authenticate_user!, except: %i[index new show replies]
  before_action :set_comment, only: %i[show edit update destroy]
  
  def index
      post_id = params[:post_id]
      @comments = Comment.parent_comments.where(post_id: post_id).order(created_at: :desc)
  end
  
  def show
  end

  def replies
    @comment = Comment.find(params[:comment_id])
    @replies = @comment.replies.order(created_at: :desc)
    
    respond_to do |format|
      format.html
    end
  end

  def new
      post_id = params[:post_id]
      parent_comment = params[:comment_id]
      @comment = Comment.new(post_id: post_id, user_id: user_signed_in? ? current_user.id : nil, comment_id: parent_comment)
      set_new_form_turbo_id
  end
  
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      respond_to do |format|
        format.html { redirect_to post_comments_path, notice: I18n.t('comment.successful_posting') }
        format.turbo_stream do
          flash.now[:notice] = I18n.t('comment.successful_posting')
          @comments = Comment.parent_comments.where(post_id: @comment.post_id).order(created_at: :desc)
          @new_comment = Comment.new(post_id: @comment.post_id)
          # @turbo_frame_id_to_update = comment_turbo_redirect_params
        end
      end
    else
      set_new_form_turbo_id
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    set_edit_form_turbo_id
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.html { redirect_to post_comments_path, notice: I18n.t('comment.successful_edit') }
        format.turbo_stream do
          flash.now[:notice] = I18n.t('comment.successful_edit')
          @turbo_frame_id_to_update = @comment.edit_frame_id
        end
      end
    else
      set_edit_form_turbo_id
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    @new_reply = Comment.new(post_id: @comment.post.id, comment_id: @comment.id)

    respond_to do |format|
      format.html { redirect_to post_comments_path(@comment.post.id), notice: I18n.t('comment.successful_deletion') }
      format.turbo_stream do
        flash.now[:notice] = I18n.t('comment.successful_deletion')
      end
    end
  end

  private

  def comment_params
      params.require(:comment).permit(:content, :post_id, :user_id, :comment_id)
  end

  def set_new_form_turbo_id
    @form_turbo_id = @comment.reply_to_turbo_frame_id
  end

  def set_edit_form_turbo_id
    @form_turbo_id = @comment.edit_frame_id
  end

  # def comment_turbo_redirect_params
  #   params.require(:turbo_frame_id)
  # end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end