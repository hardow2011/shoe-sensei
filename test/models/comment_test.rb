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
    # @valid_comment.user = nil
    # @valid_comment.content = nil

    assert @valid_comment.valid?
    refute @valid_comment.user.present?
    refute @valid_comment.content.present?
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

  test 'comment content validated on update' do
    comment = @valid_comment.dup
    comment.save
    assert comment.valid?

    comment.content = nil
    comment.save
    refute comment.valid?

    comment.content = ''
    comment.save
    refute comment.valid?

    comment.content = '<p>Hello</p>'
    comment.save
    assert comment.valid?
  end

  test 'when user is destoyed, its comment still exist with their content, but their association to the user is removed' do
    user = User.new(email: 'user@email.com',  username: 'usnme', password: 'P@tito-f3o')

    user.save
    assert user.valid?

    comments = [
      comment_1 = Comment.create(post: Post.first, user: user, content: '<p>First comment</p>'),
      comment_2 = Comment.create(post: Post.first, user: user, content: '<p>Second comment</p>'),
      comment_3 = Comment.create(post: Post.first, user: user, parent_comment: comment_1, content: '<p>Reply to first comment</p>')
    ]

    comments.each do |comment|
      assert comment.user.present?
      assert comment.content.present?
      assert comment.post.present?
    end

    user.destroy

    comments.each do |comment|
      assert comment.persisted?
      assert comment.user.destroyed?
      assert comment.content.present?
      assert comment.post.present?
    end
  end
end
