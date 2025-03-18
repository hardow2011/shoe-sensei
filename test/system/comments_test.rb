require 'application_system_test_case'

class CommentsTests < ApplicationSystemTestCase
    setup do
        @user = users(:andris)
        @comment_content = 'Very good information'
    end
    
    test 'post comment under post' do
        login(email: @user.email, password: 'An4r!s+Q')

        click_on 'Blog'

        click_on 'Read more...'

        assert_no_text @comment_content

        # Scroll down to activate the lazy loaded comments.
        # Sleep is necessary because scroll is async.
        page.scroll_to(0, 5000)
        sleep 1

        find('[name="comment[content]"]').set(@comment_content)

        click_on 'Post Comment'

        assert_text 'Comment posted successfully.'
        assert_text @comment_content
    end

    test 'reply to comment' do
        login(email: @user.email, password: 'An4r!s+Q')

        click_on 'Blog'

        click_on 'Read more...'

        assert_no_text @comment_content

        # Scroll down to activate the lazy loaded comments.
        # Sleep is necessary because scroll is async.
        page.scroll_to(0, 5000)
        sleep 1

        click_on 'Reply'

        find('.comment-reply-input').set(@comment_content)

        click_on 'Post Reply'

        assert_text 'Comment posted successfully.'
        assert_text @comment_content
    end
end