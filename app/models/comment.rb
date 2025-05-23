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
  REPLY_TO_TURBO_SUFFIX = "reply_to_comment_"
  include ActionView::RecordIdentifier
  
  belongs_to :post
  belongs_to :user, optional: true
  belongs_to :parent_comment, foreign_key: :comment_id, class_name: 'Comment', optional: true
  has_many :replies, foreign_key: :comment_id, class_name: 'Comment'

  # validates :content, presence: true, on: :create
  validate :content_format, if: -> { new_record? || content_changed? }
  validates_presence_of :post
  validates :user, presence: true, on: :create

  scope :parent_comments, -> { where(comment_id: nil) }
  scope :published, -> { where.not(content: nil) }
  scope :deleted, -> { where(content: nil) }

  def turbo_frame_id
    dom_id self
  end

  def edit_frame_id
    "edit_#{dom_id self}"
  end

  def reply_to_turbo_frame_id
    if parent_comment
        REPLY_TO_TURBO_SUFFIX + "#{parent_comment.id}"
    else
        "new_comment"
    end
  end

  def replies_for_turbo_frame_id
      "replies_for_comment_#{id}"
  end

  def reply_count_turbo_frame_id
    "#{dom_id(self)}_reply_count"
  end

  # Soft deletes the comment by making user and content nil
  def destroy
    self.update_column(:user_id, nil)
    self.update_column(:content, nil)
    self.update_column(:deleted_at, DateTime.now)
    # self.save(validate: false)
  end

  class CommentScrubber < Rails::HTML::PermitScrubber
    ALLOWED_TAGS = %w( p strong em span ul ol li )
    def Initialize
      super
      self.tags = ALLOWED_TAGS
      # self.attributes = %w( style )
    end

    def skip_node?(node)
      node.text?
    end
  end

  def deletion_message
    I18n.t('comment.deletion_message')
  end

  private

  def content_format
    # Security philosophy:
    # Validation (by rejection, not sanitization) on input. Escaping on output

    # validate by rejecting non permitted tags
    self.content = ActionController::Base.helpers.sanitize self.content, scrubber: Comment::CommentScrubber.new(prune: true)
    plain_content = ActionController::Base.helpers.strip_tags self.content


    # Check that the content without tags is not empty
    self.errors.add(:content, :blank) if (self.content.blank? or plain_content.blank?)
  end
end
