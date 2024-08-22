require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  # Clear attached files after system tests
  # https://guides.rubyonrails.org/active_storage_overview.html#system-tests
  def after_teardown
    super

    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  def sign_in_as_admin
    user = users(:charo)
    visit new_user_session_url

    fill_in "user[email]",	with: user.email
    fill_in "user[password]",	with: 'charo'

    click_on 'Log in'
  end

  def assert_img_src(img)
    assert_selector :css, "img[src=\"#{url_for(img)}\"]"
  end
  def assert_no_img_src(img)
    assert_no_selector :css, "img[src=\"#{url_for(img)}\"]"
  end
end
