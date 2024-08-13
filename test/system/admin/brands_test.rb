require 'application_system_test_case'

class Admin::BrandsTest < ApplicationSystemTestCase
  setup do
    sign_in_as_admin
  end

  test "Listing all brands" do
    click_on 'Brands'

    brands.each do |b|
      assert_text b.name
    end
  end

  test "Creating brand" do
    click_on 'Add a brand'

    fill_in "brand[name]",	with: "Adidas"
    fill_in "brand[overview]",	with: "A very hip brand!"

    click_on 'Create Brand'

    assert_text 'Brand was created successfully.'

    assert_text 'Adidas'
  end

  test "Updating brand" do
    click_on 'Brands'

    click_on 'Edit', match: :first

    assert_text 'Edit brand'

    fill_in "brand[name]",	with: "Saucony"
    fill_in "brand[overview]",	with: "I do not know much about this one."

    click_on 'Update Brand'

    assert_text 'Brand was updated successfully.'

    assert_text 'Saucony'
  end

  test 'Destroying a brand' do
    click_on 'Brands'

    assert_no_text 'ToDelete'

    assert_link 'Add a brand', count: 2

    click_on 'Add a brand', match: :first

    fill_in "brand[name]",	with: "ToDelete"
    fill_in "brand[overview]",	with: "Will be deleted"

    click_on 'Create Brand', match: :first

    assert_text 'Brand was created successfully.'

    assert_text 'ToDelete'

    click_on 'Delete', match: :first

    assert_text 'Brand was destroyed successfully.'

    assert_no_text 'ToDelete'
  end
end
