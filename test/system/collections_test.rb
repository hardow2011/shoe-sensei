require 'application_system_test_case'

class CollectionsTest < ApplicationSystemTestCase
  setup do
    @brooks = brands(:brooks)
  end

  test 'access brand collection section from homepage' do
    visit root_url

    click_on "Try Our Shoe Filter!"

    within('.models-filter') do
      check @brooks.name
    end

    click_on @brooks.models.first.name

    @brooks.collections.each do |on_collection|
      assert_text on_collection.name
      assert_text on_collection.overview
    end
  end
end
