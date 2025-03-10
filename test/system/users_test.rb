require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
    setup do
        new_user = { username: 'armandez' name: 'Armando', password: 'Velez' }
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
        fill_in "user[username]", with: new_user[:username]
        fill_in "user[email]", with: new_user[:email]
        fill_in "user[password]", with: new_user[:password]
        fill_in "user[password_confirmation]", with: new_user[:password]

        assert_enqueued_email_with 
            UserMailer.with(username: new_user[:username], email: new_user[:email]),
            :verification_email do
            click_on 'Sign Up'
        end

        email = ActionMailer::Base.deliveries.last
        html = Nokogiri::HTML(email.html_part.body.to_s)
        target_link = html.at("a:contains('Activate Account')")
        visit target_link['href']

        assert_text 'Account activated. Log in to continue.'

        fill_in "user[email]", with: user.email
        fill_in "user[password]", with: 'bruce'

        click_on 'Log In'

        assert_no_selector 'a', text: 'Join'
        assert_selector 'a', text: 'Account'
    end
    
    # test 'login' do
    #     user = users(:bruce)
    #     visit root_url

    #     assert_selector 'a', text: 'Join'
    #     click_on 'Log In'

    #     assert_text 'Log In'

    #     fill_in "user[email]", with: user.email
    #     fill_in "user[password]", with: 'bruce'

    #     click_on 'Log In'

    #     # TODO: after loggin on, the user should be brought back to the
    #     # same page he was on
    # end
end