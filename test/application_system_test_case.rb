require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def sign_in_as_admin
    user = users(:charo)
    visit new_user_session_url

    fill_in "user[email]",	with: user.email
    fill_in "user[password]",	with: 'charo'

    click_on 'Log in'
  end
end
