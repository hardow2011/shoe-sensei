class CommentsController < ApplicationController
    def new
        post_id = params[:post_id]
        @comment = Comment.new(post_id: post_id, user_id: current_user.id)
    end
    
    def create
        @comment = Comment.new(comment_params)

        if @comment.save
          redirect_to post_comments_path(post_id: @comment.post.id), notice: 'Comment posted successfully.'
        else
            render :new, status: :unprocessable_entity
        end
    end

    private

    def comment_params
        params.require(:comment).permit(:content, :post_id, :user_id)
    end
end