# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment_id :bigint
#  post_id    :bigint           not null
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_comment_id  (comment_id)
#  index_comments_on_post_id     (post_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (comment_id => comments.id)
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  
  belongs_to :post
  belongs_to :user, optional: true
  belongs_to :parent_comment, foreign_key: :comment_id, class_name: 'Comment', optional: true
  has_many :replies, foreign_key: :comment_id, class_name: 'Comment'

  validates :content, presence: true, on: :create
  validates_presence_of :post
  validates :user, presence: true, on: :create

  # TODO: rename to parent_comments
  scope :top_comments, -> { where(comment_id: nil) }

  def turbo_frame_id
    if parent_comment
        "reply_to_comment_#{parent_comment.id}"
    else
        dom_id self
    end
  end
  def replies_turbo_frame_id
      "replies_for_comment_#{id}"
  end

  def content=(value)
    # Security philosophy:
    # Validation (by rejection, not sanitization) on input. Escaping on output

    # validate by rejecting non permitted tags
    value = ActionController::Base.helpers.sanitize value, scrubber: Comment::CommentScrubber.new(prune: true)
    super(value)
  end

  # Soft deletes the comment by making user and content nil
  def destroy
    self.update({user: nil, content: nil, deleted_at: DateTime.now})
  end

  class CommentScrubber < Rails::HTML::PermitScrubber
    def Initialize
      super
      self.tags = %w( p strong em span ul ol li )
      self.attributes = %w( style )
    end

    def skip_node?(node)
      node.text?
    end
  end
end
