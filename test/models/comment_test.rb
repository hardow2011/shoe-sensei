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

    assert_includes comment.errors[:user], "must exist"
  end

  test 'comment may belong to another comment' do
    user = users(:andris)
    comment = @valid_comment
    comment.user = user

    comment.save
    assert comment.valid?
  end
end
