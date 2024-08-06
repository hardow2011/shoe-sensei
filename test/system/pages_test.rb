require 'application_system_test_case'

class PagesTest < ApplicationSystemTestCase
  setup do
    @hoka_speedgoat_5 = models(:hoka_speedgoat_5)
    @hoka_bondi_8 = models(:hoka_bondi_8)
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
      assert_text @hoka_speedgoat_5.name
      assert_text @hoka_speedgoat_5.brand.name
      assert_text @hoka_bondi_8.name
      assert_text @hoka_bondi_8.brand.name
    end

    within('.model-filter') do
      check 'Road running'
    end

    within('.filter-wrapper') do
      within('.models-grid') do
        assert_no_text @hoka_speedgoat_5.name
        assert_text @hoka_bondi_8.name
        assert_text @hoka_bondi_8.brand.name
      end
    end

    within('.model-filter') do
      has_no_field? 'Low'
      has_field? 'On'
      check 'On'
      has_field? 'Low'
    end
  end

  test 'Paginating through the shoe models in the homepage' do
    visit root_path

    within('.pagination', match: :first) do
      assert_any_of_selectors(:css, '.pagination-list > li')
      assert_any_of_selectors(:css, '.pagination-previous.is-disabled[disabled]')
      assert_any_of_selectors(:css, '.pagination-next:not(.is-disabled):not(:disabled)')

      click_on '2'
    end

    within('.model-filter') do
      check 'On'
    end

    assert_no_selector(:css, '.pagination')
  end
end
