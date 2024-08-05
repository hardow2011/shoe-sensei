require 'application_system_test_case'

class BrandsTest < ApplicationSystemTestCase
  setup do
    Rails.application.load_tasks
    Rake::Task['run_models_save_callbacks'].invoke
    @brooks = brands(:brooks)
    @hoka = brands(:hoka)
    @on = brands(:on_running)
  end
  test 'Show brand page' do
    visit root_url

    within('.model-filter') do
      check @brooks.name
    end

    within('.models-grid') do
      click_on @brooks.name, match: :first
    end

    assert_text @brooks.name
    assert_text @brooks.overview

    within('.model-filter') do
      assert_no_text 'Brand'

      brands.each do |b|
        has_no_field? b.name
      end
    end

    within('.models-grid') do
      @brooks.models.first(3).each do |model|
        assert_text model.name
      end

      @hoka.models.first(3).each do |model|
        assert_no_text model.name
      end

      @on.models.first(3).each do |model|
        assert_no_text model.name
      end
    end

    within('.model-filter') do
      check 'High'
    end

    # TODO: assert only models with high cushion present
    brooks_with_high_cushioning = @brooks.models.select { |m| m.tags[:cushioning] == 'High'}.first(3)
    brooks_without_high_cushioning = @brooks.models - @brooks.models.select { |m| m.tags[:cushioning] == 'High'}.first(3)
    within('.models-grid') do
      brooks_with_high_cushioning.each do |model|
        assert_text model.name
      end

      brooks_without_high_cushioning.each do |model|
        assert_no_text model.name
      end
    end
  end
end
