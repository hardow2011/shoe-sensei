require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
    include Devise::Test::IntegrationHelpers

    setup do
        @new_user = { username: 'armandez', email: 'ar.lez@mail.com', name: 'aaaaaa', password: 'P@tito-f3o' }
    end

    def login(with_username=false)
        user = users(:yordania)
        visit root_url

        assert_selector 'a', text: 'Join'

        click_on 'Join'

        assert_text "Don't have an account yet?"
        assert_no_text "Already have an account?"

        fill_in "user[login]", with: with_username ? user[:username] : user[:email]
        fill_in "user[password]", with: 'yordania'

        click_on 'Log In'

        assert_text 'Logged in successfully.'

        assert_no_selector 'a', text: 'Join'
        assert_selector 'a', text: 'Account'
    end
    
    test 'signup' do
        visit root_url

        assert_selector 'a', text: 'Join'
        click_on 'Join'

        assert_text "Don't have an account yet?"
        assert_no_text "Already have an account?"
        assert_selector 'a', text: 'Sign Up'
        click_on 'Sign Up'

        assert_text "Already have an account?"
        assert_no_text "Don't have an account yet?"
        fill_in "user[username]", with: @new_user[:username]
        fill_in "user[email]", with: @new_user[:email]
        fill_in "user[password]", with: @new_user[:password]
        fill_in "user[password_confirmation]", with: @new_user[:password]

        click_on 'Sign Up'

        sleep 1

        email = ActionMailer::Base.deliveries.last
        html = Nokogiri::HTML(email.body.to_s)
        target_link = html.at("a:contains('Confirm my account')")
        visit target_link['href']

        assert_text 'Your email address has been successfully confirmed.'

        fill_in "user[login]", with: @new_user[:email]
        fill_in "user[password]", with: @new_user[:password]

        click_on 'Log In'

        assert_no_selector 'a', text: 'Join'
        assert_selector 'a', text: 'Account'
    end
    
    test 'login with email' do
        login
    end

    test 'login with username' do
        login(with_username=true)
    end

    test 'logout' do
        login

        find('.account-dropdown').hover

        click_on 'Log Out'

        assert_text 'Logged out successfully.'

        assert_selector 'a', text: 'Join'
        assert_no_selector 'a', text: 'Account'
    end
end