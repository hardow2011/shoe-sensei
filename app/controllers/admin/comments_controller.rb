class Admin::CommentsController < Admin::AdminController
    before_action :set_comment, only: [:destroy]
    before_action :set_comments, only: [:index]
    def index
    end

    def destroy
        @comment.destroy
        set_comments
        respond_to do |format|
            format.html { redirect_to admin_comments_path, notice: 'Comment was deleted succesfully.' }
            format.turbo_stream do
                 flash.now[:notice] = 'Comment was deleted succesfully.'
            end
        end      
    end

    private

    def set_comment
        @comment = Comment.find(params['id'])
    end

    def set_comments
        selected_user = params['user_id'].present? ? User.find(params['user_id']) : nil
        selected_post = params['post_id'].present? ? Post.find(params['post_id']) : nil
        selected_filter = params['filter']

        case selected_filter
        when 'published'
            @comments = Comment.published
        when 'deleted'
            @comments = Comment.deleted
        else
            @comments = Comment.published
        end

        if selected_user
            @comments = @comments.where(user: selected_user)
        end

        if selected_post
            @comments = @comments.where(post: selected_post)
        end

        @comments = @comments.order(created_at: :desc)
    end
end