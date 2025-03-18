module TurboFrame
    def comment_turbo_frame_id(comment)
        if comment.parent_comment
            "reply_to_comment_#{comment.parent_comment.id}"
        else
            dom_id comment
        end
    end
end