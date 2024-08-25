require "test_helper"

class BrandTest < ActiveSupport::TestCase
  setup do
    @brooks = brands(:brooks)
    @brooks_logo = File.open('test/fixtures/files/hoka-logo.webp')
  end
  test "valid brand" do
    brand = Brand.new(name: 'Adidas', overview: 'A very hip brand!', logo: @brooks_logo)
    brand.save
    assert brand.valid?
  end

  test "invalid without name" do
    brand = Brand.new(overview: 'A very hip brand!')
    brand.save
    refute brand.valid?, 'brand valid without name'
    assert_not_empty brand.errors[:name], 'no validation error for name present'
  end

  test "invalid without logo" do
    brand = Brand.new(name: 'Adidas', overview: 'A very hip brand!')
    brand.save
    refute brand.valid?, 'brand valid without name'
    assert_not_empty brand.errors[:logo], 'no validation error for name present'
  end

  test "invalid without overview" do
    brand = Brand.new(name: 'Adidas')
    brand.save
    refute brand.valid?, 'brand valid without overview'
    assert_not_empty brand.errors[:overview], 'no validation error for overview present'
  end

  test "correct name parameterization to handle" do
    brand = Brand.new(name: 'This is an imaginary Company, Or what?', overview: 'A very hip brand!')
    brand.save
    assert_equal brand.handle, 'this-is-an-imaginary-company-or-what', 'handle malformed'
  end

  test 'unique name' do
    brand = Brand.new(name: @brooks.name, overview: 'Does not matter')
    brand.save
    refute brand.valid?, 'brand valid with non unique name'
    assert_not_empty brand.errors[:name], 'no validation errors for non unique name'
  end

  test 'unique handle' do
    brand = Brand.new(name: @brooks.name + '?', overview: 'Does not matter')
    brand.save
    refute brand.valid?, 'brand valid with non unique handle'
    assert_not_empty brand.errors[:handle], 'no validation errors for non unique handle'
  end
end
