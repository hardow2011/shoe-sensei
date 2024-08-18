require 'test_helper'

class CollectionTest < ActiveSupport::TestCase
  setup do
    @new_balance = brands(:new_balance)
    @fresh_foam_1080v13 = collections(:new_balance_fresh_foam_1080)
  end
  test "valid collection" do
    collection = Collection.new(name: 'Cookies n Cream', overview: 'A very sweet snack', brand: @new_balance)
    collection.save
    assert collection.valid?
  end

  test 'invalid without name' do
    collection = Collection.new(overview: 'A very sweet snack', brand: @new_balance)
    collection.save
    refute collection.valid?
    assert_not_empty collection.errors[:name], 'no validation error for name present'
  end

  test 'invalid without overview' do
    collection = Collection.new(name: 'Cookies n cream', brand: @new_balance)
    collection.save
    refute collection.valid?
    assert_not_empty collection.errors[:overview], 'no validation error for name present'
  end

  test "correct name parameterization to handle" do
    collection = Collection.new(name: 'Cookies n Cream', overview: 'A very sweet snack', brand: @new_balance)
    collection.save
    assert_equal collection.handle, 'cookies-n-cream', 'handle malformed'
  end

  test 'unique name within brand' do
    collection = Collection.new(name: @fresh_foam_1080v13.name, overview: 'Does not matter', brand: @fresh_foam_1080v13.brand)
    collection.save
    refute collection.valid?, 'brand valid with non unique name'
    assert_not_empty collection.errors[:name], 'no validation errors for non unique name'
  end

  test 'unique handle' do
    collection = Collection.new(name: @fresh_foam_1080v13.name + '(?)!', overview: 'Does not matter', brand: @fresh_foam_1080v13.brand)
    collection.save
    refute collection.valid?, 'brand valid with non unique handle'
    assert_not_empty collection.errors[:handle], 'no validation errors for non unique handle'
  end
end
