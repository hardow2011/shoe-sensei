require 'application_system_test_case'

class CommentsTests < ApplicationSystemTestCase
    setup do
        @user = users(:andris)
    end
    
    test 'post comment under post' do
        comment_content = 'Very good information'
        login(email: @user, password: @user)

        click_on 'Blog'

        click_on 'Read more...'

        assert_no_text comment_content

        find('input[name="comment[content]"]').set(comment_content)

        click_on 'Post Comment'

        assert_text 'Comment posted succesfully.'
        assert_text comment_content
    end
end