require 'application_system_test_case'

class BrandsTest < ApplicationSystemTestCase
  setup do
    Rails.application.load_tasks
    Rake::Task['run_models_save_callbacks'].invoke
    @brooks = brands(:brooks)
    @hoka = brands(:hoka)
    @on_running = brands(:on_running)
  end

  test 'show brands index page' do
    visit root_url

    within('.navbar') do
      # find('.brands-dropdown').hover
      click_on 'Brands'
    end

    brands.each do |b|
      assert_text b.name
      assert_text b.overview
    end
  end

  test 'show brand page' do
    visit root_url

    within('.model-filter') do
      check @on_running.name
    end

    within('.models-grid') do
      click_on @on_running.name, match: :first
    end

    @on_running.collections.each do |on_collection|
      assert_text on_collection.name
      assert_text on_collection.overview
    end

    assert_text @on_running.name
    assert_text @on_running.overview

    within('.model-filter') do
      assert_no_text 'Brand'

      brands.each do |b|
        has_no_field? b.name
      end
    end

    within('.models-grid') do
      @on_running.models.only_still_in_production.first(3).each do |model|
        assert_text model.name
      end

      @on_running.models.discontinued.each do |model|
        assert_no_text model.name
      end

      @brooks.models.only_still_in_production.first(3).each do |model|
        assert_no_text model.name
      end

      @hoka.models.first(3).each do |model|
        assert_no_text model.name
      end
    end

    within('.model-filter') do
      has_field? 'High'
      check 'High'
    end

    on_with_high_cushioning = @brooks.models.select { |m| m.tags[:cushioning] == '2'}.first(3)
    on_without_high_cushioning = (@brooks.models - on_with_high_cushioning).first(3)

    within('.models-grid') do
      on_with_high_cushioning.each do |model|
        assert_text model.name
      end

      on_without_high_cushioning.each do |model|
        assert_no_text model.name
      end
    end
  end
end
