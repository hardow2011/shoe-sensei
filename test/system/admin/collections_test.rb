require 'application_system_test_case'

class Admin::CollectionsTest < ApplicationSystemTestCase
  setup do
    sign_in_as_admin
    @on_brand = brands(:on_running)
  end

  test 'listing all collections' do
    click_on 'Collections'

    collections.each do |c|
      assert_text "#{c.name} from #{c.brand.name}"
    end
  end

  test 'creating a collection' do
    click_on 'Add a collection'

    fill_in "collection[name]",	with: "MadeUpCollection"
    fill_in "collection[overview_en]",	with: "For challenging trails."
    fill_in "collection[overview_es]",	with: "Para senderos desafiantes"
    select 'On', from: 'collection[brand_id]'

    click_on 'Create Collection'

    assert_text 'Collection was created successfully.'

    assert_text 'MadeUpCollection'
  end

  test 'creating a collection from a brand' do
    click_on 'Brands'

    click_on @on_brand.name

    assert_text 'Edit brand'

    assert_text @on_brand.name
    assert_text @on_brand.overview

    click_on 'Add Collection'

    fill_in "collection[name]",	with: "MadeUpCollection"
    fill_in "collection[overview_en]",	with: "For challenging trails."
    fill_in "collection[overview_es]",	with: "Para senderos desafiantes"

    click_on 'Add Collection'

    assert_text 'Collection was created successfully.'

    assert_text @on_brand.name
    assert_text @on_brand.overview

    assert_text 'MadeUpCollection'
  end

  test 'updating a collection' do
    click_on 'Collections'

    click_on 'Edit', match: :first

    fill_in "collection[name]",	with: "UpdatedCollection"
    fill_in "collection[overview_en]",	with: "A minimalistic casual shoe."
    fill_in "collection[overview_es]",	with: "Un zapato minimalista y casual."

    click_on 'Update Collection'

    assert_text 'Collection was updated successfully.'

    assert_text 'UpdatedCollection'
  end

  test 'destroying a collection' do
    click_on 'Collections'

    click_on 'Add a collection', match: :first

    fill_in "collection[name]",	with: "ToDelete"
    fill_in "collection[overview_en]",	with: "Will be deleted"
    fill_in "collection[overview_es]",	with: "Será borrado"
    select 'On', from: 'collection[brand_id]'

    click_on 'Create Collection'

    assert_text 'Collection was created successfully.'

    assert_text 'ToDelete'

    click_button 'Delete', match: :first

    assert_text 'Collection was destroyed successfully.'

    assert_no_text 'ToDelete'
  end
end
