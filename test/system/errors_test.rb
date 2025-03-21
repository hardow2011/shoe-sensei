require 'application_system_test_case'

class ErrorsTest < ApplicationSystemTestCase
    test 'display 404 page on page not found' do
        visit '/cewcswcrevgr'

        assert_text "404"
        assert_text "There seem to have been an error"
        assert_text "Don't worry, we've been alerted and will investigate the issue shortly."
    end
end