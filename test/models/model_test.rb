require "test_helper"

class ModelTest < ActiveSupport::TestCase
  setup do
    @on_cloud_x = collections(:on_cloud_x)
    @tags = { activities: ['Walking', 'Standing'], cushioning: 1, support: 'Neutral' }
    @hoka_speedgoat_5_image = File.open('test/fixtures/files/hoka-speedgoat-5.WEBP')
  end
  test "valid model" do
    model = Model.new(name: 'Uncle Iroh', apma_accepted: true, discontinued: false, heel_to_toe_drop: 4, weight: 154.6,
                       tags: @tags, collection: @on_cloud_x, image: @hoka_speedgoat_5_image)
    model.save
    assert model.valid?
  end

  test "invalid without name" do
    model = Model.new(apma_accepted: true, discontinued: false, heel_to_toe_drop: 4, weight: 154.6,
                       tags: @tags, collection: @on_cloud_x)
    model.save
    refute model.valid?
    assert_not_empty model.errors[:name]
  end

  test "invalid without image" do
    model = Model.new(name: 'Uncle Iroh', apma_accepted: true, discontinued: false, heel_to_toe_drop: 4, weight: 154.6,
                       tags: @tags, collection: @on_cloud_x)
    model.save
    refute model.valid?
    assert_not_empty model.errors[:image]
  end

  test "invalid without apma_accepted" do
    model = Model.new(name: 'Uncle Iroh', discontinued: false, heel_to_toe_drop: 4, weight: 154.6,
                       tags: @tags, collection: @on_cloud_x)
    model.save
    refute model.valid?
    assert_not_empty model.errors[:apma_accepted]
  end

  test "invalid without discontinued" do
    model = Model.new(name: 'Uncle Iroh', apma_accepted: true, heel_to_toe_drop: 4, weight: 154.6,
                       tags: @tags, collection: @on_cloud_x)
    model.save
    refute model.valid?
    assert_not_empty model.errors[:discontinued]
  end

  test "invalid without heel_to_toe_drop" do
    model = Model.new(name: 'Uncle Iroh', apma_accepted: true, discontinued: false, weight: 154.6,
                       tags: @tags, collection: @on_cloud_x)
    model.save
    refute model.valid?
    assert_not_empty model.errors[:heel_to_toe_drop]
  end

  test "invalid without weight" do
    model = Model.new(name: 'Uncle Iroh', apma_accepted: true, discontinued: false, heel_to_toe_drop: 4,
                       tags: @tags, collection: @on_cloud_x)
    model.save
    refute model.valid?
    assert_not_empty model.errors[:weight]
  end

  test "invalid without tags" do
    model = Model.new(name: 'Uncle Iroh', apma_accepted: true, discontinued: false, weight: 154.6, heel_to_toe_drop: 4,
                       collection: @on_cloud_x, image: @hoka_speedgoat_5_image)
    model.save
    refute model.valid?
    assert_not_empty model.errors[:activities]
    assert_not_empty model.errors[:cushioning]
    assert_not_empty model.errors[:support]

    model.tags = @tags.except(:activities, :cushioning)

    model.save
    refute model.valid?

    assert_not_empty model.errors[:activities]
    assert_not_empty model.errors[:cushioning]
    assert_empty model.errors[:support]

    model.tags = @tags.except(:activities)

    model.save
    refute model.valid?

    assert_not_empty model.errors[:activities]
    assert_empty model.errors[:cushioning]
    assert_empty model.errors[:support]

    model.tags = @tags

    model.save
    assert model.valid?

    assert_empty model.errors[:activities]
    assert_empty model.errors[:cushioning]
    assert_empty model.errors[:support]
  end

end
