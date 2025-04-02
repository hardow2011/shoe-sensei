require_relative './admin_system_test_case'

class Admin::UsersTest < Admin::AdminSystemTestCase
    # include ActionController::Base.helpers
    setup do
        @users_non_admin = User.non_admin.filter { |u| !u.admin }
        @users_non_admin_confirmed = users.filter { |u| !u.admin and u.confirmed? }
        @users_non_admin_unconfirmed = users.filter { |u| !u.admin and !u.confirmed? }
        sign_in_as_admin
    end
    
    test 'listing non-admin users' do
        click_on 'Users'

        @users_non_admin.each do |u|
            assert_text u.email
            assert_text u.username
        end

        click_on 'Confirmed'

        @users_non_admin_confirmed.each do |u|
            assert_text u.email
            assert_text u.username
        end

        @users_non_admin_unconfirmed.each do |u|
            assert_no_text u.email
            assert_no_text u.username
        end

        click_on 'Unconfirmed'

        @users_non_admin_unconfirmed.each do |u|
            assert_text u.email
            assert_text u.username
        end

        @users_non_admin_confirmed.each do |u|
            assert_no_text u.email
            assert_no_text u.username
        end
    end

    test 'showing a user' do
        user = @users_non_admin_confirmed.find { |u| u.email == 'harold@email.com'}
        
        click_on 'Users'

        within("##{dom_id(user)}") do
            click_on 'Edit'
        end

        assert_selector "input[name='user[email]'][value='#{user.email}']"

        assert_selector "input[name='user[username]'][value='#{user.username}']"
        # assert created_at datetime format
        assert_selector "input[name='user[created_at]'][value='#{I18n.l(user.created_at, format: :long)}']"
        # assert confirmed_at datetime format
        assert_selector "input[name='user[confirmed_at]'][value='#{I18n.l(user.confirmed_at, format: :long)}']"

        assert_button 'Delete User'

        # TODO: finish test
        return

        within('.comments') do
            user.comments.each do |c|
                assert_text ActionController::Base.helpers.strip_tags(c.content)
                assert_text "Posted on #{I18n.l(c.created_at, format: :long)}"
                # TODO: assert confirmed_at datetime format
                assert_selector 'a', text: "Post: #{c.post.title}"

                if c.parent_comment
                    assert_selector 'a', text: "Reply to: #{strip_tags c.parent_comment.content}"
                end
            end
        end

    end

end