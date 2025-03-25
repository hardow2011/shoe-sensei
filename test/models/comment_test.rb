require "test_helper"

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    post = posts(:my_doctor_told_me)
    user = users(:yordania)
    @valid_comment = Comment.new(post: post, user: user, content: '<p>Interesting information!</p>')
  end

  test 'valid comment' do
    @valid_comment.save

    assert @valid_comment.valid?
  end

  test 'comment must belong to a post' do
    comment = @valid_comment
    comment.post = nil

    comment.save
    refute comment.valid?

    assert_includes comment.errors[:post], "must exist"
  end

  test 'comment must belong to a user' do
    comment = @valid_comment
    comment.user = nil

    comment.save
    refute comment.valid?

    assert_includes comment.errors[:user], "can't be blank"
  end

  test 'comment may belong to another comment' do
    user = users(:andris)
    comment = @valid_comment
    comment.user = user

    comment.save
    assert comment.valid?
  end

  test 'when comment is destroyed by user, it still exists but the content and associated user are removed' do
    @valid_comment.save
    assert @valid_comment.valid?
    refute @valid_comment.deleted_at.present?

    @valid_comment.destroy
    @valid_comment.user = nil
    @valid_comment.content = nil

    assert @valid_comment.valid?
    assert @valid_comment.deleted_at.present?
  end

  test 'comment is completely deleted when post is deleted' do
    @valid_comment.save
    assert @valid_comment.valid?

    post = @valid_comment.post
    post.destroy

    @valid_comment.destroyed?
  end

  test 'comment content sanitized properly' do
    # Content can't be nil
    @valid_comment.content = nil
    @valid_comment.save
    refute @valid_comment.valid?
    assert_includes @valid_comment.errors[:content], "can't be blank"

    # Content can't be blank
    @valid_comment.content = ''
    @valid_comment.save
    refute @valid_comment.valid?
    assert_includes @valid_comment.errors[:content], "can't be blank"

    # Content can't allow empty text
    @valid_comment.content = '<p><strong></strong></p>'\
                              '<p><em></em></p>'\
                              '<p><ol><li></li></ol></p>'\
                              '<p><ul><li></li></ul></p>'
    @valid_comment.save
    assert_includes @valid_comment.errors[:content], "can't be blank"

    # Content rejects unpermitted tags
    @valid_comment.content = "<p><script>alert('hello')</script></p>"
    @valid_comment.save
    refute @valid_comment.valid?
    assert_includes @valid_comment.errors[:content], "can't be blank"

    # Content rejects unpermitted tags
    @valid_comment.content = "<p><script>alert('hello')</script></p>"\
                              "<p>Hello</p>"
    @valid_comment.save
    assert @valid_comment.valid?
  end
end
