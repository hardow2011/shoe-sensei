require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    @charo = users(:charo)
    @charo_psswd = 'charo'
  end
  test "Logging in" do
    visit new_user_session_url

    fill_in "email",	with: @charo.email
    fill_in "password",	with: @charo_psswd

    click_on 'Log in'

    within('.admin-sidebar') do
      click_on 'Brands'
    end

    assert_text 'Brands'

    brands.each do |b|
      assert_text b.name
    end

    asser_text 'Create brand'
  end

  test 'Logging out' do
    sign_in @charo

    click_on 'Log out'
  end
end
