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
    select 'On', from: 'collection[brand]'

    click_on 'Create Collection'

    assert_text 'Collection was created successfully.'

    assert_text 'MadeUpCollection'
  end

  test 'updating a collection' do
    click_on 'Collections'

    click_on 'Edit', match: :first

    fill_in "collection[name]",	with: "UpdatedCollection"
    fill_in "collection[overview]",	with: "A minimalistic casual shoe."

    click_on 'Update collection'

    assert_text 'Collection was updated successfully.'

    assert_text 'UpdatedCollection'
  end

  test 'destroying a collection' do
    click_on 'Collections'

    click_on 'Add a collection'

    fill_in "collection[name]",	with: "ToDelete"
    fill_in "collection[overview]",	with: "Will be deleted"
    select 'On', from: 'collection[brand]'

    click_on 'Create Collection'

    assert_text 'Collection was created successfully.'

    assert_text 'ToDelete'

    click_on 'Delete', match: :first

    assert_text 'Collection was deleted successfully.'

    assert_no_text 'ToDelete'
  end
end
