require_relative './admin_system_test_case'

class Admin::CommentsTest < Admin::AdminSystemTestCase
    setup do
        sign_in_as_admin
        @published_comments = comments.filter { |c| c.content.present? }
        @deleted_comments = comments.filter { |c| !c.content.present? }
    end

    test 'list comments' do
        click_on 'Comments'

        assert_comments(@published_comments, @deleted_comments, false, false)
    end

    test 'delete comment' do
        click_on 'Comments'
        comment = @published_comments.find { |c| c.content == '<strong>Changed my mind</strong>' }

        assert_text ActionController::Base.helpers.strip_tags(comment.content)

        within("##{dom_id(comment)}") do
            accept_alert 'Are you sure that you want to delete this comment?' do
                click_on 'Delete'
            end
        end

        assert_text 'Comment was deleted succesfully.'

        assert_no_text ActionController::Base.helpers.strip_tags(comment.content)

        click_on 'Deleted'

        assert_no_text ActionController::Base.helpers.strip_tags(comment.content)
    end
end