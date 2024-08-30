require 'application_system_test_case'

class ModelsTest < ApplicationSystemTestCase
  setup do
    sign_in_as_admin
    @hoka_speedgoat_5 = models(:hoka_speedgoat_5)
    @hoka_speedgoat_collection = collections(:hoka_speedgoat)
    @hoka_bondi_collection = collections(:hoka_bondi)
    @brooks_ghost_max_collection = collections(:brooks_ghost_max)
  end

  test 'listing all models' do
    click_on 'Models'

    models.each do |m|
      assert_text "#{m.name} from #{m.collection.name}"
    end
  end

  test 'creating a model' do
    click_on 'Models'

    assert_text 'Models', count: 2
    assert_text 'Add a model', count: 2

    click_on 'Add a model', match: :first

    assert_no_text 'Gaviota 74'

    assert_text 'New model'

    fill_in "model[name]",	with: "Gaviota 74"
    attach_file 'model[image]', 'test/fixtures/files/brooks-logo.webp', make_visible: true
    check "model[tags][apma_accepted]"
    check "model[tags][discontinued]"
    uncheck "model[tags][discontinued]"
    fill_in "model[heel_to_toe_drop]",	with: "8"
    fill_in "model[weight]",	with: "598.2"
    select @hoka_bondi_collection.name_with_brand, from: "model[collection_id]"
    check "Road running"
    check "Walking"
    choose "High"
    choose "Neutral"

    click_on 'Create Model'

    assert_no_text 'New model'

    assert_text 'Model was created successfully.'

    assert_text 'Models', count: 2
    assert_text 'Add a model', count: 2
    assert_text "Gaviota 74 from #{@hoka_bondi_collection.name}"
  end

  test "creating a model from a collection" do
    click_on 'Collections'

    assert_text 'Collections', count: 2
    assert_text 'Add a collection', count: 2

    click_on @brooks_ghost_max_collection.name

    assert_no_text 'Gaviota 74'

    assert_text 'Add Model'
    click_on 'Add Model'

    fill_in "model[name]",	with: "Gaviota 74"
    attach_file 'model[image]', 'test/fixtures/files/brooks-logo.webp', make_visible: true
    check "model[tags][apma_accepted]"
    check "model[tags][discontinued]"
    uncheck "model[tags][discontinued]"
    fill_in "model[heel_to_toe_drop]",	with: "8"
    fill_in "model[weight]",	with: "598.2"
    check "Road running"
    check "Walking"
    choose "High"
    choose "Neutral"

    click_on 'Add Model'

    assert_text 'Model was created successfully.'

    assert_text 'Collections', count: 1
    assert_text 'Add a collection', count: 1

    assert_field "collection[name]", with: @brooks_ghost_max_collection.name
    assert_field "collection[overview]", with: @brooks_ghost_max_collection.overview

    assert_text 'Gaviota 74'
  end


  test 'updating a model' do
    new_model_name = 'UpdatedModel'
    click_on 'Models'

    assert_text 'Models', count: 2
    assert_text 'Add a model', count: 2

    assert_text @hoka_speedgoat_5.name

    click_on @hoka_speedgoat_5.name

    assert_text 'Edit model'

    assert_field "model[name]", with: @hoka_speedgoat_5.name
    fill_in "model[name]",	with: new_model_name

    assert_checked_field "model[tags][apma_accepted]"
    assert_no_checked_field "model[tags][discontinued]"

    assert_field "model[heel_to_toe_drop]", with: @hoka_speedgoat_5.heel_to_toe_drop
    fill_in "model[heel_to_toe_drop]",	with: "2"

    select @brooks_ghost_max_collection.name_with_brand, from: "model[collection_id]"

    @hoka_speedgoat_5.tags[:activities].each do |a|
      assert_checked_field "model[tags][activities][]", with: a
    end

    check 'Walking'

    choose "model[tags][cushioning_level]", with: 1
    choose "model[tags][support]", with: "stability"

    click_on 'Update Model'

    assert_text 'Model was updated successfully.'

    assert_no_text 'Edit model'

    assert_text 'Models', count: 2
    assert_text 'Add a model', count: 2
    assert_no_text @hoka_speedgoat_5.name
    assert_text new_model_name
  end

  test 'destroying model' do
    model = models.first
    click_on 'Models'

    assert_text model.name
    click_on 'Delete', match: :first

    assert_text 'Model was destroyed successfully.'

    # TODO: find way to click specific delete button
    # assert_no_text model.name
  end
end
