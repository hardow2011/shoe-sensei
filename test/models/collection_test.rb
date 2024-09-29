require 'test_helper'

class CollectionTest < ActiveSupport::TestCase
  setup do
    @new_balance = brands(:new_balance)
    @fresh_foam_1080v13 = collections(:new_balance_fresh_foam_1080)
    @valid_collection = Collection.new(name: 'Intergalactic Comfort', overview_en: 'Cushioning out of this world', overview_es: 'Amortiguación fuera de este mundo',
                                        brand: @new_balance)
  end
  test "valid collection" do
    collection = @valid_collection
    collection.save
    assert collection.valid?
  end

  test 'invalid without name' do
    collection = @valid_collection
    collection.name = nil
    collection.save
    refute collection.valid?
    assert_not_empty collection.errors[:name], 'no validation error for name present'
  end

  test 'invalid without English overview' do
    collection = @valid_collection
    collection.overview_en = nil
    collection.save
    refute collection.valid?
    assert_not_empty collection.errors[:overview_en], 'no validation error for English ovewrview present'
  end

  test 'invalid without Spanish overview' do
    collection = @valid_collection
    collection.overview_es = nil
    collection.save
    refute collection.valid?
    assert_not_empty collection.errors[:overview_es], 'no validation error for Spanish ovewrview present'
  end

  test "correct name parameterization to handle" do
    collection = @valid_collection
    collection.save
    assert_equal 'intergalactic-comfort', collection.handle, 'handle malformed'
  end

  test 'unique name within brand' do
    collection = @new_balance.dup
    collection.save
    refute collection.valid?, 'brand valid with non unique name'
    assert_not_empty collection.errors[:name], 'no validation errors for non unique name'
  end

  test 'unique handle' do
    collection = @new_balance.dup
    collection.save
    refute collection.valid?, 'brand valid with non unique handle'
    assert_not_empty collection.errors[:handle], 'no validation errors for non unique handle'
  end
end
