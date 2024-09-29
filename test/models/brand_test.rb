require "test_helper"

class BrandTest < ActiveSupport::TestCase
  setup do
    @brooks = brands(:brooks)
    @brooks_logo = File.open('test/fixtures/files/hoka-logo.webp')
  end
  test "valid brand" do
    brand = Brand.new(name: 'Adidas', overview_en: 'A very hip brand!', overview_es: 'Una marca muy popular!', company_color: '#2232bf', logo: @brooks_logo)
    brand.save
    assert brand.valid?
  end

  test "invalid without company color" do
    brand = Brand.new(name: 'Adidas', overview_en: 'A very hip brand!', overview_es: 'Una marca muy popular!', logo: @brooks_logo)
    brand.save
    refute brand.valid?, 'brand valid without company color'
    assert_not_empty brand.errors[:company_color], 'no validation error for company_color present'
  end

  test "invalid without name" do
    brand = Brand.new(overview_en: 'A very hip brand!', overview_es: 'Una marca muy popular!', company_color: '#2232bf', logo: @brooks_logo)
    brand.save
    refute brand.valid?, 'brand valid without name'
    assert_not_empty brand.errors[:name], 'no validation error for name present'
  end

  test "invalid without logo" do
    brand = Brand.new(name: 'Adidas', overview_en: 'A very hip brand!', overview_es: 'Una marca muy popular!',  company_color: '#2232bf')
    brand.save
    refute brand.valid?, 'brand valid without name'
    assert_not_empty brand.errors[:logo], 'no validation error for name present'
  end

  test "invalid without English overview" do
    brand = Brand.new(name: 'Adidas', overview_es: 'Una marca muy popular!', company_color: '#2232bf', logo: @brooks_logo)
    brand.save
    refute brand.valid?, 'brand valid without English overview'
    assert_not_empty brand.errors[:overview_en], 'no validation error for English overview present'
  end

  test "invalid without Spanish overview" do
    brand = Brand.new(name: 'Adidas', overview_en: 'A very hip brand!', company_color: '#2232bf', logo: @brooks_logo)
    brand.save
    refute brand.valid?, 'brand valid without Spanish overview'
    assert_not_empty brand.errors[:overview_es], 'no validation error for Spanish overview present'
  end

  test "correct name parameterization to handle" do
    brand = Brand.new(name: 'This is an imaginary Company, Or what?', overview: 'A very hip brand!', company_color: '#2232bf', logo: @brooks_logo)
    brand.save
    assert_equal 'this-is-an-imaginary-company-or-what', brand.handle, 'handle malformed'
  end

  test 'unique name' do
    brand = Brand.new(name: @brooks.name, overview: 'Does not matter', company_color: '#2232bf', logo: @brooks_logo)
    brand.save
    refute brand.valid?, 'brand valid with non unique name'
    assert_not_empty brand.errors[:name], 'no validation errors for non unique name'
  end

  test 'unique handle' do
    brand = Brand.new(name: @brooks.name + '?', overview: 'Does not matter', company_color: '#2232bf', logo: @brooks_logo)
    brand.save
    refute brand.valid?, 'brand valid with non unique handle'
    assert_not_empty brand.errors[:handle], 'no validation errors for non unique handle'
  end
end
