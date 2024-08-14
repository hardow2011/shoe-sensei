require 'application_system_test_case'

class Admin::CollectionsTest < ApplicationSystemTestCase
  setup do
    sign_in_as_admin
  end

  test 'listing all collections' do
    click_on 'Collections'

    collections.each do |c|
      assert_text c.name
    end
  end

  test 'creating a collection' do
    click_on 'Add a collection'

    fill_in "collection[name]",	with: "MadeUpCollection"
    fill_in "collection[overview]",	with: "For challenging trails."
    select 'On', from: 'collection[brand_id]'

    click_on 'Create Collection'

    assert_text 'Collection was created successfully.'

    assert_text 'MadeUpCollection'
  end

  test 'creating a collection from a brand' do
    click_on 'Brands'

    click_on 'On'

    click_on 'Edit', match: :first

    assert_text 'Edit collection'

    click_on 'Add Collection'

    fill_in "collection[name]",	with: "MadeUpCollection"
    fill_in "collection[overview]",	with: "For challenging trails."

    click_on 'Update Brand'

    click_on 'On'

    click_on 'Edit'

    assert_text 'MadeUpCollection'
  end

  test 'updating a collection' do
    click_on 'Collections'

    click_on 'Edit', match: :first

    fill_in "collection[name]",	with: "UpdatedCollection"
    fill_in "collection[overview]",	with: "A minimalistic casual shoe."

    click_on 'Update Collection'

    assert_text 'Collection was updated successfully.'

    assert_text 'UpdatedCollection'
  end

  test 'destroying a collection' do
    click_on 'Collections'

    click_on 'Add a collection', match: :first

    fill_in "collection[name]",	with: "ToDelete"
    fill_in "collection[overview]",	with: "Will be deleted"
    select 'On', from: 'collection[brand_id]'

    click_on 'Create Collection'

    assert_text 'Collection was created successfully.'

    assert_text 'ToDelete'

    click_button 'Delete', match: :first

    assert_text 'Collection was destroyed successfully.'

    assert_no_text 'ToDelete'
  end
end
