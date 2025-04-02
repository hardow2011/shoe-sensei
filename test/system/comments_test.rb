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

        find('div[name="comment[content]"]').set(@comment_content)

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

        click_on 'Reply', match: :first

        find('.comment-reply-input').set(@comment_content)

        click_on 'Post Reply'

        assert_text 'Comment posted successfully.'
        assert_text @comment_content
    end

    test 'delete comment' do
        login(email: @user.email, password: 'An4r!s+Q')

        click_on 'Blog'

        click_on 'Read more...'

        assert_no_text @comment_content

        # Scroll down to activate the lazy loaded comments.
        # Sleep is necessary because scroll is async.
        page.scroll_to(0, 5000)
        sleep 1

        find('div[name="comment[content]"]').set(@comment_content)

        click_on 'Post Comment'

        assert_text 'Comment posted successfully.'
        assert_text @comment_content

        accept_alert 'Are you sure that you want to delete this comment?' do
            click_on 'Delete', match: :first
        end

        assert_text 'Comment deleted successfully.'
    end

    test 'update comment' do
        new_comment = "I changed my mind"
        login(email: @user.email, password: 'An4r!s+Q')

        click_on 'Blog'

        click_on 'Read more...'

        assert_no_text @comment_content

        # Scroll down to activate the lazy loaded comments.
        # Sleep is necessary because scroll is async.
        page.scroll_to(0, 5000)
        sleep 1

        find('div[name="comment[content]"]').set(@comment_content)

        click_on 'Post Comment'

        assert_text 'Comment posted successfully.'
        assert_text @comment_content

        click_on 'Edit Comment', match: :first

        within('#comments') do
            find('div[name="comment[content]"]').set(new_comment)
        end

        click_on 'Save Edits'

        assert_text 'Comment edited successfully.'
        assert_text new_comment
        assert_no_text @comment_content
    end
end