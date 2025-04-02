require_relative './admin_system_test_case'

class Admin::CommentsTest < Admin::AdminSystemTestCase
    setup do
        sign_in_as_admin
        @published_comments = comments.filter { |c| c.content.present? }
        @deleted_comments = comments.filter { |c| !c.content.present? }
    end

    test 'list comments' do
        click_on 'Comments'

        assert_selector 'li.is-active', text: 'Published'
        assert_selector 'li:not(.is-active)', text: 'Deleted'

        @published_comments.each do |c|
            assert_text ActionController::Base.helpers.strip_tags(c.content)
            if c.parent_comment
                assert_text "Replying to: Comment ##{c.parent_comment.id}"
            end
            assert_text "Under: Post ##{c.post.id}"
        end

        # TODO: finish this test
        return

        click_on 'Deleted'

        assert_selector 'a:not(.is-active)', text: 'Published'
        assert_selector 'a.is-active', text: 'Deleted'

        @deleted_comments.each do |c|
            assert_text strip_tags(c.content)
        end
    end
end