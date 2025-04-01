require_relative './admin_system_test_case'

class Admin::ModelsTest < Admin::AdminSystemTestCase
    # include ActionController::Base.helpers
    setup do
        @users_non_admin = users.filter { |u| !u.admin }
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

    # test 'showing a user' do
    #     user = @users_non_admin_confirmed.last
    #     click_on 'Users'

    #     click_on 'Edit', match: :first

    #     assert_text user.email
    #     assert_text user.username
    #     # TODO: assert created_at datetime format
    #     assert_text '21 march 2025 at 07:41 AM'
    #     # TODO: assert confirmed_at datetime format
    #     assert_text '21 march 2025 at 07:41 AM'

    #     assert_button 'Delete User'

    #     user.comments.each |c| do
    #         assert_text strip_tags(c.content)
    #         assert_text c.created_at
    #         # TODO: assert confirmed_at datetime format
    #         assert_selector 'a', text: "Post: #{c.post.title}"

    #         if c.parent_comment
    #             assert_selector 'a', text: "Reply to: #{strip_tags c.parent_comment.content}"
    #         end
    #     end

    # end
end