# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates :password, length: { minimum: 8 }
  validates :password, format: { with: /[~!@#$%^&*()_\-+=`{}\[\]|\\:;"'<>.,?\/]+/, 
                                  message: 'must contain at least one special character' }
  validates :password, format: { with: /[A-Z]+/, 
                                message: 'must contain at least one uppercase letter' }
  validates :password, format: { with: /[a-z]+/, 
                                message: 'must contain at least one lowercase letter' }
  validates :password, format: { with: /[0-9]+/, 
                                message: 'must contain at least one number' }

  with_options if: :admin? do |admin|
    admin.validates :username, absence: true
  end

  with_options unless: :admin? do |non_admin|
    non_admin.validates :username, presence: true
    non_admin.validates :username, length: { minimum: 3 }
    non_admin.validates :username, length: { maximum: 30 }
    non_admin.validates :username, format: { with: /\A[a-zA-Z0-9_-]+\z/, 
                                              message: 'must only contain alpha-numeric characters, dashes and underscores' }
    non_admin.validates :username, uniqueness: true
  end
end
