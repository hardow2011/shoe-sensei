require 'application_system_test_case'

class Admin::BrandsTest < ApplicationSystemTestCase
  setup do
    sign_in_as_admin
    @hoka = brands(:hoka)
  end

  test "listing all brands" do
    click_on 'Brands'

    brands.each do |b|
      assert_img_src b.logo.variant(:thumb)
      assert_text b.name
    end
  end

  test "creating brand" do
    click_on 'Add a brand'

    fill_in "brand[name]",	with: "MadeUpBrand"

    find('#loaded-img', visible: false)

    # TODO: find way to test file preview
    # attach_file 'test/fixtures/files/brooks-logo.webp', make_visible: true do
    #   find('.file-cta').click
    # end

    attach_file 'brand[logo]', 'test/fixtures/files/brooks-logo.webp', make_visible: true

    fill_in "brand[company_color]",	with: "#2232bf"

    fill_in "brand[overview_en]",	with: "A very hip brand!"
    fill_in "brand[overview_es]",	with: "Una marca muy popular!"

    click_on 'Create Brand'

    # TODO: find way to test file preview
    # find('#loaded-img', visible: true)

    assert_text 'Brand was created successfully.'

    assert_text 'MadeUpBrand'
  end

  # TODO: find way to test file preview when updating
  test "updating brand" do
    click_on 'Brands'

    click_on @hoka.name

    assert_text 'Edit brand'

    @hoka.collections.each do |c|
      assert_text c.name
      assert_no_text "#{c.name} from #{c.brand.name}"
    end

    fill_in "brand[name]",	with: "Saucony"
    attach_file 'brand[logo]', 'test/fixtures/files/new-balance-logo.png', make_visible: true
    fill_in "brand[company_color]",	with: "#2232bf"
    fill_in "brand[overview_en]",	with: "I do not know much about this one."
    fill_in "brand[overview_es]",	with: "No sé mucho de esta."

    click_on 'Update Brand'

    assert_text 'Brand was updated successfully.'

    assert_text 'Saucony'
  end

  test 'destroying a brand' do
    click_on 'Brands'

    assert_no_text 'ToDelete'

    assert_link 'Add a brand', count: 2

    click_on 'Add a brand', match: :first

    fill_in "brand[name]",	with: "ToDelete"
    attach_file 'brand[logo]', 'test/fixtures/files/on-logo.png', make_visible: true
    fill_in "brand[overview_en]",	with: "Will be deleted"
    fill_in "brand[overview_es]",	with: "Será borrada"

    click_on 'Create Brand', match: :first

    assert_text 'Brand was created successfully.'

    assert_text 'ToDelete'

    # click_on clicking on edit for some reason
    click_button 'Delete', match: :first

    assert_text 'Brand was destroyed successfully.'

    assert_no_text 'ToDelete'
  end
end
