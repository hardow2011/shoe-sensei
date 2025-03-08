require_relative './admin_system_test_case'

class Admin::DeviseTest < Admin::AdminSystemTestCase
  setup do
    sign_in_as_admin
  end

  test "logging in" do
    within('.admin-menubar') do
      click_on 'Brands'
    end

    assert_text 'Brands'

    assert_text 'Dashboard'
    assert_text 'CONTENT MANAGEMENT'
  end

  # test 'logging out' do
  #   sign_in @charo

  #   click_on 'Log out'
  # end
end
