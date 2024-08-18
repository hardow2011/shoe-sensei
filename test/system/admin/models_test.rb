require 'application_system_test_case'

class ModelsTest < ApplicationSystemTestCase
  setup do
    sign_in_as_admin
    @on_cloudsurfer_trail_1 = models(:on_cloudsurfer_trail_1)
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
    fill_in "model[overview]",	with: "A brand new Gaviota with imaginary cushioning and knee support!"
    check "model[apma_accepted]"
    check "model[discontinued]"
    uncheck "model[discontinued]"
    fill_in "model[heel_to_toe_drop]",	with: "8"
    fill_in "model[weight]",	with: "598.2"
    select "Bondi (Hoka)", "model[collection_id]"
    check "model[tags][activities][Road running]"
    check "model[tags][activities][Walking]"
    choose "model[tags][cushioning][2]"
    choose "model[tags][support][neutral]"

    click_on 'Create Model'

    assert_text 'Model was created successfully.'

    assert_no_text 'New model'

    assert_text 'Models', count: 2
    assert_text 'Add a model', count: 2
    assert_text 'Gaviota 74'
  end


  test 'updating a model' do
    new_model_name = 'UpdatedModel'
    click_on 'Models'

    assert_text 'Models', count: 2
    assert_text 'Add a model', count: 2

    assert_text @on_cloudsurfer_trail_1.name

    click_on @on_cloudsurfer_trail_1.name

    assert_text 'Edit model'

    fill_in "model[name]",	with: new_model_name
    fill_in "model[overview]",	with: "You will walk on branches"
    check "model[apma_accepted]"
    check "model[discontinued]"
    fill_in "model[heel_to_toe_drop]",	with: "2"
    fill_in "model[weight]",	with: "78.2"
    select "Ghost Max (Brooks)", "model[collection_id]"
    check "model[tags][activities][Road running]"
    uncheck "model[tags][activities][Trail running]"
    choose "model[tags][cushioning][0]"
    choose "model[tags][support][stability]"

    click_on 'Update Model'

    assert_text 'Model was updated successfully.'

    assert_no_text 'Edit model'

    assert_text 'Models', count: 2
    assert_text 'Add a model', count: 2
    assert_no_text @on_cloudsurfer_trail_1.name
    assert_text new_model_name
  end

  test 'destroying model' do
    model = models.first
    click_on 'Models'

    assert_text model.name
    click_on 'Delete', match: :first

    assert_text 'Model was destroyed successfully.'

    a
    ssert_no_text model.name
  end
end
