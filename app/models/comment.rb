class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :comment, as: :parent_comment, optional: true
end
