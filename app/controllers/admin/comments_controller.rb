class Admin::CommentsController < Admin::AdminController
    def index
        @selected_filter = request.params['filter']
    
        case @selected_filter
        when 'published'
            @comments = Comment.published
        when 'deleted'
            @comments = Comment.deleted
        else
            @comments = Comment.published
        end

        @comments = @comments.order(created_at: :desc)
    end
end