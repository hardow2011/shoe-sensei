# == Schema Information
#
# Table name: blogs
#
#  id         :bigint           not null, primary key
#  handle     :string           not null
#  published  :boolean          not null
#  tags       :string           default([]), not null, is an Array
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_blogs_on_handle  (handle) UNIQUE
#
class Blog < ApplicationRecord
  has_rich_text :content_en
  has_rich_text :content_es
end
