class Admin::CommentsController < Admin::AdminController
    def index
        @selected_user = params['user_id'] ? User.find(params['user_id']) : nil
        @selected_post = params['post_id'] ? Post.find(params['post_id']) : nil
        @selected_filter = params['filter']

        case @selected_filter
        when 'published'
            @comments = Comment.published
        when 'deleted'
            @comments = Comment.deleted
        else
            @comments = Comment.published
        end

        if @selected_user
            @comments.where(user: @selected_user)
        end

        if @selected_post
            @comments.where(post: @selected_post)
        end

        @comments = @comments.order(created_at: :desc)
    end
end