require_relative './admin_system_test_case'

class Admin::DeviseTest < Admin::AdminSystemTestCase
  setup do
  end

  test "logging in" do
    sign_in_as_admin
    within('.admin-menubar') do
      click_on 'Brands'
    end

    assert_text 'Brands'

    assert_text 'Dashboard'
    assert_text 'CONTENT MANAGEMENT'
  end

  test "non-admin user cannot log in admin interface" do
    user = users(:andris)
    visit new_admin_session_url

    fill_in "admin[login]",	with: user.email
    fill_in "admin[password]",	with: 'An4r!s+Q'

    click_on 'Log In'

    assert_text 'Invalid Username or Email or password.'
    assert_no_text 'Dashboard'
  end

  # test 'logging out' do
  #   sign_in @charo

  #   click_on 'Log out'
  # end
end
