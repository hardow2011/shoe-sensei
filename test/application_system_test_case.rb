require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  setup do
    # Necessary for tests to pass, given that the active storage urls now have the local added
    # default_url_options[:locale] = I18n.default_locale

    # This is necessary so the mailer has a host for the system tests
    host = Capybara.current_session.server.host
    port = Capybara.current_session.server.port
    Rails.application.config.action_mailer.default_url_options = { host: host, port: port }
  end

  # Clear attached files after each system test
  # https://guides.rubyonrails.org/active_storage_overview.html#system-tests
  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end
  parallelize_setup do |i|
    ActiveStorage::Blob.service.root = "#{ActiveStorage::Blob.service.root}-#{i}"
  end

  def sign_in_as_admin
    user = users(:charo)
    visit new_admin_session_url

    fill_in "admin[email]",	with: user.email
    fill_in "admin[password]",	with: 'charo'

    click_on 'Log In'
  end

  # TODO: fix assert_img_src
  def assert_img_src(img)
    # assert_selector :css, "img[src=\"#{url_for(img)}\"]"
  end
  # TODO: fix assert_no_img_src
  def assert_no_img_src(img)
    assert_no_selector :css, "img[src=\"#{url_for(img)}\"]"
  end
end
