require 'application_system_test_case'

class SearchTest < ApplicationSystemTestCase
    def setup
        Searchkick.enable_callbacks
    end

    def teardown
        Searchkick.disable_callbacks
    end

    test 'autocomplete' do
        visit root_path
        find('input.aa-Input').set("Brooks")
        within('.aa-List') do
            click_on 'Brooks'
        end
        assert_current_path(brand_path(brands(:brooks).handle, locale: :en))
    end
end