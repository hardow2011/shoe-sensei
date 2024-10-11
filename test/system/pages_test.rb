require 'application_system_test_case'

class PagesTest < ApplicationSystemTestCase
  include FilterPagination
  setup do
    @hoka_speedgoat_5 = models(:hoka_speedgoat_5)
    @hoka_bondi_8 = models(:hoka_bondi_8)
    @on_cloud_x_4 = models(:on_cloud_x_4)
    @brooks = brands(:brooks)
    @brooks_ghost_max_1 = models(:brooks_ghost_max_1)
  end
  test "filtering the shoe models in the homepage" do
    visit root_path

    within('.title-container') do
      click_on "Try Our Shoe Filter"
    end

    within('.models-grid') do
      assert_any_of_selectors(:css, 'div.model-box')
    end

    within('.models-filter') do
      has_field? 'Training and gym'

      has_field? 'Brooks'
      has_field? 'On'
      has_field? 'HOKA'
      has_field? 'New Balance'

      check 'HOKA'

      has_no_field? 'Training and gym'
    end

    within('.models-grid') do
      assert_img_src @hoka_speedgoat_5.brand.logo.variant(:thumb)
      assert_text @hoka_speedgoat_5.name
      assert_text @hoka_speedgoat_5.brand.name
      assert_text @hoka_bondi_8.name
      assert_text @hoka_bondi_8.brand.name
    end

    within('.models-filter') do
      check 'Road running'
    end

    within('.models-grid') do
      assert_no_text @hoka_speedgoat_5.name
      assert_text @hoka_bondi_8.name
      assert_text @hoka_bondi_8.brand.name
    end

    within('.models-filter') do
      has_no_field? 'Low'
      has_field? 'On'
      check 'On'
      has_field? 'Low'

      uncheck 'Road running'
    end

    within("[data-model='On Cloud X 4']") do
      assert_text @on_cloud_x_4.name
      assert_selector 'a', text: @on_cloud_x_4.brand.name
      assert_text "Weight: #{@on_cloud_x_4.weight} gr / #{@on_cloud_x_4.weight(to_oz = true)} oz"
      assert_text "Cushioning: #{@on_cloud_x_4.cushioning_name.capitalize}"

      within('.cushioning_info') do
        assert_selector 'span.icon', count: 3
        assert_selector 'span.icon.has-text-danger', count: 1
        assert_selector 'span.icon:not(.has-text-danger)', count: 2
      end

      within('.apma_info') do
        assert_selector 'span.icon', count: 1
        assert_selector 'span.icon.has-text-danger'
      end
    end

    within("[data-model='HOKA Bondi 8']") do
      assert_text @hoka_bondi_8.name
      assert_selector 'a', text: @hoka_bondi_8.brand.name
      assert_text "Weight: #{@hoka_bondi_8.weight} gr / #{@hoka_bondi_8.weight(to_oz = true)} oz"
      assert_text "Cushioning: #{@hoka_bondi_8.cushioning_name.capitalize}"

      within('.cushioning_info') do
        assert_selector 'span.icon', count: 3
        assert_selector 'span.icon.has-text-primary-30', count: 3
        assert_no_selector 'span.icon.has-text-danger'
      end

      within('.apma_info') do
        assert_selector 'span.icon', count: 1
        assert_selector 'span.icon.has-text-primary-30'
      end
    end
  end

  test 'paginating through the shoe models in the homepage' do
    visit root_path

    within('.title-container') do
      click_on "Try Our Shoe Filter"
    end

    within('.pagination', match: :first) do
      assert_any_of_selectors(:css, '.pagination-list > li')
      assert_any_of_selectors(:css, '.pagination-previous.is-disabled[disabled]')
      assert_any_of_selectors(:css, '.pagination-next:not(.is-disabled):not(:disabled)')

      click_on '2'
    end

    within('.models-filter') do
      check 'On'
    end

    assert_no_selector(:css, '.pagination')
  end

  test 'sorting the models in the homepage' do
    visit root_url

    within('.title-container') do
      click_on "Try Our Shoe Filter"
    end

    sort_options = FilterPagination::SORTING_OPTIONS.map { |o| o[0]}

    within('.models-filter') do
      assert_select :models_sorting, with_options: sort_options
    end

    # Assert default 'Name (A to Z)' is selected
    within('.models-filter') do
      assert_select :models_sorting, selected: 'Name (A to Z)'
    end

    # Assert models ordered by default 'Name (A to Z)'
    within('.models-grid') do
      all(:css, '.model-box').each_with_index do |model_box, i|
        model_box.assert_text(Model.only_still_in_production.order(:name)[i].name)
      end
    end

    # Select 'Cushioning (low to high) order and assert selected
    within('.models-filter') do
      select 'Cushioning (low to high)', from: :models_sorting
      assert_select :models_sorting, selected: 'Cushioning (low to high)'
    end

    # Assert models ordered by selected 'Cushioning (low to high)'
    within('.models-grid') do
      all(:css, '.model-box').each_with_index do |model_box, i|
        model_box.assert_text(Model.only_still_in_production.order_by_cushioning_level[i].name)
      end
    end

    # Select 'Cushioning (high to low)' order and assert selected
    within('.models-filter') do
      select 'Cushioning (high to low)', from: :models_sorting
      assert_select :models_sorting, selected: 'Cushioning (high to low)'
    end

    # Assert models ordered by selected 'Cushioning (high to low)'
    within('.models-grid') do
      all(:css, '.model-box').each_with_index do |model_box, i|
        model_box.assert_text(Model.only_still_in_production.order_by_cushioning_level(:desc)[i].name)
      end
    end

    # Select 'Weight (low to high)' order and assert selected
    within('.models-filter') do
      select 'Weight (low to high)', from: :models_sorting
      assert_select :models_sorting, selected: 'Weight (low to high)'
    end

    # Assert models ordered by selected 'Weight (low to high)'
    within('.models-grid') do
      all(:css, '.model-box').each_with_index do |model_box, i|
        model_box.assert_text(Model.only_still_in_production.order_by_weight[i].name)
      end
    end

    # Select 'Weight (high to low)' order and assert selected
    within('.models-filter') do
      select 'Weight (high to low)', from: :models_sorting
      assert_select :models_sorting, selected: 'Weight (high to low)'
    end

    # Assert models ordered by selected 'Weight (high to low)'
    within('.models-grid') do
      all(:css, '.model-box').each_with_index do |model_box, i|
        model_box.assert_text(Model.only_still_in_production.order_by_weight(:desc)[i].name)
      end
    end

    # Select 'Heel to toe drop (low to high)' order and assert selected
    within('.models-filter') do
      select 'Heel to toe drop (low to high)', from: :models_sorting
      assert_select :models_sorting, selected: 'Heel to toe drop (low to high)'
    end

    # Assert models ordered by selected 'Heel to toe drop (low to high)'
    within('.models-grid') do
      all(:css, '.model-box').each_with_index do |model_box, i|
        model_box.assert_text(Model.only_still_in_production.order_by_heel_to_toe_drop[i].name)
      end
    end

    # Select 'Heel to toe drop (high to low)' order and assert selected
    within('.models-filter') do
      select 'Heel to toe drop (high to low)', from: :models_sorting
      assert_select :models_sorting, selected: 'Heel to toe drop (high to low)'
    end

    # Assert models ordered by selected 'Heel to toe drop (high to low)'
    within('.models-grid') do
      all(:css, '.model-box').each_with_index do |model_box, i|
        model_box.assert_text(Model.only_still_in_production.order_by_heel_to_toe_drop(:desc)[i].name)
      end
    end
  end

  test 'using additional filters in the homepage' do
    visit root_url

    within('.title-container') do
      click_on "Try Our Shoe Filter"
    end

    within('.models-filter') do
      has_field? 'APMA accepted only?'
      has_field? 'Show discontinued models?'

      has_field? @brooks.name
      check @brooks.name

      @brooks.models.only_still_in_production.first(3).each do |model|
        assert_text model.name
      end

      @brooks.models.discontinued.each do |model|
        assert_no_text model.name
      end

      check 'Show discontinued models?'
      check 'Brooks'

      @brooks.models.only_still_in_production(false).first(3).each do |model|
        assert_text model.name
      end

      @brooks.models.first(3).each do |model|
        assert_text model.name
      end
    end
  end

  test 'show message when no models available for selection' do
    visit root_url

    within('.title-container') do
      click_on "Try Our Shoe Filter"
    end

    assert_no_text @brooks_ghost_max_1.name

    within('.models-filter') do
      check 'Brooks'

      assert_no_field 'Low'
      assert_field 'Medium'
      assert_no_field 'High'
    end

    @brooks.models.only_still_in_production(true).each do |model|
      assert_text model.name
    end

    @brooks.models.discontinued.each do |model|
      assert_no_text model.name
    end

    within('.models-filter') do
      assert_field 'Show discontinued models?'
      check 'Show discontinued models?'

      assert_field 'High'
    end

    @brooks.models.each do |model|
      assert_text model.name
    end

    within('.models-filter') do
      check 'High'
    end

    @brooks.models.discontinued.each do |model|
      assert_text model.name
    end

    @brooks.models.only_still_in_production(true).each do |model|
      assert_no_text model.name
    end

    within('.models-filter') do
      uncheck 'Show discontinued models?'
    end

    @brooks.models.each do |model|
      assert_no_text model.name
    end

    assert_text 'No available models for your selection.'
  end
end
