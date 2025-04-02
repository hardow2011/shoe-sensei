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
            assert_text "Posted on: #{I18n.l(c.created_at, format: :long)}"
            if c.parent_comment
                assert_text "Replying to: Comment ##{c.parent_comment.id}"
            end
            assert_text "Under: Post ##{c.post.id}"
        end

        click_on 'Deleted'

        assert_selector 'li:not(.is-active)', text: 'Published'
        assert_selector 'li.is-active', text: 'Deleted'

        @deleted_comments.each do |c|
            assert_text I18n.t('comment.deleted')
            assert_text "Posted on: #{I18n.l(c.created_at, format: :long)}"
            if c.parent_comment
                assert_text "Replying to: Comment ##{c.parent_comment.id}"
            end
            assert_text "Under: Post ##{c.post.id}"
        end
    end
end