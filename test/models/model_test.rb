require "test_helper"

class ModelTest < ActiveSupport::TestCase
  setup do
    @on_cloud_x = collections(:on_cloud_x)
    @hoka_speedgoat_5_image = File.open('test/fixtures/files/hoka-speedgoat-5.webp')

    valid_tags = { activities: ['walking', 'standing'], cushioning_level: 1, support: 'neutral', apma_accepted: true, discontinued: false }
    @valid_model = Model.new(name: 'Uncle Iroh', heel_to_toe_drop: 4, weight: 154.6,
                              tags: valid_tags, collection: @on_cloud_x, image: @hoka_speedgoat_5_image)
  end
  test "valid model" do
    model = @valid_model
    model.save
    assert model.valid?
  end

  test "invalid without name" do
    model = @valid_model
    model.name = nil
    model.save
    refute model.valid?
    assert_not_empty model.errors[:name]
  end

  test "invalid without unique name within collection" do
    model = @on_cloud_x.models.first.dup
    refute model.valid?
    assert_not_empty model.errors[:name], 'no validation errors for non unique name'
  end


  test "invalid without unique handle within collection" do
    model = @on_cloud_x.models.first.dup
    model.save
    refute model.valid?
    assert_not_empty model.errors[:handle], 'no validation errors for non unique handle'
  end

  test "invalid without image" do
    model = @valid_model
    model.image = nil
    model.save
    refute model.valid?
    assert_not_empty model.errors[:image]
  end

  test "invalid without heel_to_toe_drop" do
    model = @valid_model
    model.heel_to_toe_drop = nil
    model.save
    refute model.valid?
    assert_not_empty model.errors[:heel_to_toe_drop]
  end

  test "invalid without weight" do
    model = @valid_model
    model.weight = nil
    model.save
    refute model.valid?
    assert_not_empty model.errors[:weight]
  end

  # TODO: finish testing
  test "invalid without tags" do
    model = @valid_model.dup
    model.tags = nil
    model.save
    refute model.valid?
    assert_not_empty model.errors[:activities]
    assert_not_empty model.errors[:cushioning_level]
    assert_not_empty model.errors[:support]
    assert_not_empty model.errors[:apma_accepted]
    assert_not_empty model.errors[:discontinued]

    model.tags[:activities] = @valid_model.tags[:activities]

    model.save
    refute model.valid?

    assert_empty model.errors[:activities]
    assert_not_empty model.errors[:cushioning_level]
    assert_not_empty model.errors[:support]
    assert_not_empty model.errors[:apma_accepted]
    assert_not_empty model.errors[:discontinued]

    model.tags[:cushioning_level] = @valid_model.tags[:cushioning_level]

    model.save
    refute model.valid?

    assert_empty model.errors[:activities]
    assert_empty model.errors[:cushioning_level]
    assert_not_empty model.errors[:support]
    assert_not_empty model.errors[:apma_accepted]
    assert_not_empty model.errors[:discontinued]

    model.tags[:support] = @valid_model.tags[:support]

    model.save
    refute model.valid?

    assert_empty model.errors[:activities]
    assert_empty model.errors[:cushioning_level]
    assert_empty model.errors[:support]
    assert_not_empty model.errors[:apma_accepted]
    assert_not_empty model.errors[:discontinued]

    model.tags[:apma_accepted] = @valid_model.tags[:apma_accepted]

    model.save
    refute model.valid?

    assert_empty model.errors[:activities]
    assert_empty model.errors[:cushioning_level]
    assert_empty model.errors[:support]
    assert_empty model.errors[:apma_accepted]
    assert_not_empty model.errors[:discontinued]

    model.tags[:discontinued] = @valid_model.tags[:discontinued]

    model.save
    refute model.valid?

    assert_empty model.errors[:activities]
    assert_empty model.errors[:cushioning_level]
    assert_empty model.errors[:support]
    assert_empty model.errors[:apma_accepted]
    assert_empty model.errors[:discontinued]
  end

end
