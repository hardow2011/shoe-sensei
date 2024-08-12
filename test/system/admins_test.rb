require 'application_system_test_case'

class AdminsTest < ApplicationSystemTestCase
  setup do
    @charo = users(:charo)
    @charo_psswd = 'charo'
  end
  test "Logging in" do
    visit new_user_session_url

    fill_in "user[email]",	with: @charo.email
    fill_in "user[password]",	with: @charo_psswd

    click_on 'Log in'

    within('.admin-menubar') do
      click_on 'Brands'
    end

    assert_text 'Brands'

    assert_text 'Dashboard'
    assert_text 'CONTENT MANAGEMENT'
  end

  # test 'Logging out' do
  #   sign_in @charo

  #   click_on 'Log out'
  # end
end
