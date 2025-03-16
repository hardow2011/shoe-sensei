require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
    include Devise::Test::IntegrationHelpers

    setup do
        @new_user = { username: 'armandez', email: 'ar.lez@mail.com', name: 'aaaaaa', password: 'P@tito-f3o' }
        @yordania = users(:yordania)
    end

    def login(username: nil, email: nil, password: nil)
        visit root_url

        assert_selector 'a', text: 'Join'

        click_on 'Join'

        assert_text "Don't have an account yet?"
        assert_no_text "Already have an account?"

        fill_in "user[login]", with: username ? username : email
        fill_in "user[password]", with: password

        click_on 'Log In'

        assert_text 'Logged in successfully.'

        assert_no_selector 'a', text: 'Join'
        assert_selector 'a', text: 'Account'
    end

    def visit_email_link(text)
        sleep 1

        email = ActionMailer::Base.deliveries.last
        html = Nokogiri::HTML(email.body.to_s)
        target_link = html.at("a:contains('#{text}')")
        visit target_link['href']
    end

    def logout
        find('.account-dropdown').hover

        click_on 'Log Out'
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

        visit_email_link('Confirm my account')

        assert_text 'Your email address has been successfully confirmed.'

        fill_in "user[login]", with: @new_user[:email]
        fill_in "user[password]", with: @new_user[:password]

        click_on 'Log In'

        assert_no_selector 'a', text: 'Join'
        assert_selector 'a', text: 'Account'
    end
    
    test 'login with email' do
        login(email: @yordania.email, password: 'yordania')
    end

    test 'login with username' do
        login(username: @yordania.username, password: 'yordania')
    end

    test 'logout' do
        login(email: @yordania.email, password: 'yordania')

        logout

        assert_text 'Logged out successfully.'

        assert_selector 'a', text: 'Join'
        assert_no_selector 'a', text: 'Account'
    end

    test 'change email' do
        login(email: @yordania.email, password: 'yordania')

        find('.account-dropdown').hover

        click_on 'Settings'

        fill_in 'user[email]', with: 'new@email.com'

        click_on 'Update'

        assert_text 'You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirmation link to confirm your new email address.'

        visit_email_link('Confirm my account')

        assert_text 'Your email address has been successfully confirmed.'

        logout

        login(email: 'new@email.com', password: 'yordania')
    end
end
