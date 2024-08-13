class Admin::DeviseTest < ApplicationSystemTestCase
  setup do
    sign_in_as_admin
  end

  test "Logging in" do
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
