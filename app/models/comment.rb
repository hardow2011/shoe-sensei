# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment_id :bigint
#  post_id    :bigint           not null
#  user_id    :bigint           not null
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
  belongs_to :post
  belongs_to :user
  belongs_to :parent_comment, foreign_key: :comment_id, class_name: 'Comment', optional: true
  has_many :replies, foreign_key: :comment_id, class_name: 'Comment'

  validates :content, presence: true
  validates_presence_of :post
  validates_presence_of :user

  scope :top_comments, -> { where(comment_id: nil) }
end
