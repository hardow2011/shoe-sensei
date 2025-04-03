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
        published_comments = comments.filter { |c| c.content.present? && c.user_id == user.id }
        deleted_comments = comments.filter { |c| !c.content.present? && c.user_id == user.id  }
        
        click_on 'Users'

        within("##{dom_id(user)}") do
            click_on 'Edit'
        end

        assert_selector "input[name='user[email]'][value='#{user.email}']"

        assert_selector "input[name='user[username]'][value='#{user.username}']"
        assert_selector "input[name='user[created_at]'][value='#{I18n.l(user.created_at, format: :long)}']"
        assert_selector "input[name='user[confirmed_at]'][value='#{I18n.l(user.confirmed_at, format: :long)}']"

        assert_button 'Delete User'

        # asserting user comments
        assert_comments(published_comments, deleted_comments)
    end

end