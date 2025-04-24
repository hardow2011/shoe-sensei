require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
    include Devise::Test::IntegrationHelpers

    setup do
        @new_user = { username: 'armandez', email: 'ar.lez@mail.com', name: 'aaaaaa', password: 'P@tito-f3o' }
        @yordania = users(:yordania)
    end

    def visit_email_link(text)
        sleep 1

        email = ActionMailer::Base.deliveries.last
        html = Nokogiri::HTML(email.html_part.body.to_s)
        target_link = html.at("a:contains('#{text}')")
        visit target_link['href']
    end

    def logout
        find('.account-dropdown').hover

        assert_button 'Log Out'

        click_on 'Log Out'

        sleep 0.1
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

        assert_text "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."

        visit_email_link('Confirm my account')

        assert_text 'Your email address has been successfully confirmed.'

        fill_in "user[login]", with: @new_user[:email]
        fill_in "user[password]", with: @new_user[:password]

        click_on 'Log In'

        assert_no_selector 'a', text: 'Join'
        assert_selector 'a', text: 'Account'
    end
    
    test 'login with email' do
        login(email: @yordania.email, password: '*V4D83i2u!$4^t@3w6&H38uY&Cb6*%r^^$i2&')
    end

    test 'login with username' do
        login(username: @yordania.username, password: '*V4D83i2u!$4^t@3w6&H38uY&Cb6*%r^^$i2&')
    end

    test 'logout' do
        login(email: @yordania.email, password: '*V4D83i2u!$4^t@3w6&H38uY&Cb6*%r^^$i2&')

        logout

        assert_text 'Logged out successfully.'

        assert_selector 'a', text: 'Join'
        assert_no_selector 'a', text: 'Account'
    end

    test 'change email' do
        new_email = 'new@email.com'
        login(email: @yordania.email, password: '*V4D83i2u!$4^t@3w6&H38uY&Cb6*%r^^$i2&')

        find('.account-dropdown').hover

        click_on 'Settings'

        fill_in 'user[email]', with: new_email

        click_on 'Update'

        assert_text 'You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirmation link to confirm your new email address.'

        visit_email_link('Confirm my account')

        assert_text 'Your email address has been successfully confirmed.'

        logout

        login(email: new_email, password: '*V4D83i2u!$4^t@3w6&H38uY&Cb6*%r^^$i2&')
    end

    test 'change password' do
        new_password = 'pppppppp'
        login(email: @yordania.email, password: '*V4D83i2u!$4^t@3w6&H38uY&Cb6*%r^^$i2&')

        find('.account-dropdown').hover

        click_on 'Settings'

        fill_in 'user[password]', with: new_password
        fill_in 'user[password_confirmation]', with: new_password

        click_on 'Update'

        assert_text "Your account has been updated successfully."

        logout

        login(email: @yordania.email, password: new_password)
    end

    test 'delete account' do
        login(email: @yordania.email, password: '*V4D83i2u!$4^t@3w6&H38uY&Cb6*%r^^$i2&')

        find('.account-dropdown').hover

        click_on 'Settings'

        accept_alert 'Are you sure that you want to delete your account?' do
            click_link 'Cancel my account'
        end

        assert_text 'Bye! Your account has been successfully cancelled. We hope to see you again soon.'

        assert_selector 'a', text: 'Join'
        assert_no_selector 'a', text: 'Account'
    end

    test 'recover password' do
        new_password = 'kkkkkkkk'
        
        visit root_url

        assert_selector 'a', text: 'Join'

        click_on 'Join'

        assert_selector 'a', text: 'Forgot your password?'
        click_on 'Forgot your password?'

        fill_in 'user[email]', with: @yordania.email
        click_on 'Send me reset password instructions'

        assert_text 'You will receive an email with instructions on how to reset your password in a few minutes.'

        visit_email_link('Change my password')

        fill_in 'user[password]', with: new_password
        fill_in 'user[password_confirmation]', with: new_password

        click_on 'Change my password'

        assert_text 'Your password has been changed successfully. You are now signed in.'

        assert_no_selector 'a', text: 'Join'
        assert_selector 'a', text: 'Account'
    end

    test 'resend confirmation instructions' do
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

        assert_text "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."

        assert_selector 'a', text: 'Join'
        click_on 'Join'

        assert_selector 'a', text: "Didn't receive confirmation instructions?"
        click_on "Didn't receive confirmation instructions?"

        fill_in "user[email]", with: @new_user[:email]
        click_on "Resend confirmation instructions"

        assert_text "You will receive an email with instructions for how to confirm your email address in a few minutes."

        visit_email_link('Confirm my account')

        assert_text "Your email address has been successfully confirmed."

        login(email: @new_user[:email], password: @new_user[:password])
    end

    test "admin user cannot log in non-admin interface" do
        admin_user = users(:charo)
        visit root_url

        assert_selector 'a', text: 'Join'

        click_on 'Join'

        assert_text "Don't have an account yet?"
        assert_no_text "Already have an account?"

        fill_in "user[login]", with: admin_user[:username]
        fill_in "user[password]", with: 'Ch@ro123'

        click_on 'Log In'

        assert_no_text 'Logged in successfully.'
        assert_text 'Invalid Username or Email or password.'

        assert_selector 'a', text: 'Join'
        assert_no_selector 'a', text: 'Account'
      end
end
