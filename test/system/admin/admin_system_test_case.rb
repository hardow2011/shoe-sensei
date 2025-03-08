require "application_system_test_case"

class Admin::AdminSystemTestCase < ApplicationSystemTestCase
    # TODO: set the admin subdomain.
    # But the tests will pass with any subdomain
    Capybara.server_host = 'admin.localhost'
end