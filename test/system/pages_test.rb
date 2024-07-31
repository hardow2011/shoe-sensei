require 'application_system_test_case'

class PagesTest < ApplicationSystemTestCase
  setup do
    @hoka_speedgoat_5 = models(:hoka_speedgoat_5)
  end
  test "Filtering the shoe models in the homepage" do
    visit root_path

    within('.models-grid') do
      assert_any_of_selectors(:css, 'div.model-box')
    end

    within('.model-filter') do
      has_field? 'Training and gym'

      has_field? 'Brooks'
      has_field? 'On'
      has_field? 'HOKA'
      has_field? 'New Balance'

      check 'HOKA'

      has_no_field? 'Training and gym'
    end

    within('.models-grid') do
      assert_text @hoka_speedgoat_5.full_name
    end
  end
end
