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
#  subdomain              :string           default(""), not null
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
  VALID_SUBDOMAINS = ['', 'admin']

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, authentication_keys: [ :login ],
         request_keys: { subdomain: false }

  with_options if: :admin? do |admin|
    admin.validates :username, absence: true
    # Only validate password on create.
    # TODO: also validate password on update in the future
    admin.validates :password, length: { minimum: 8 }, on: :create
    admin.validates :password, format: { with: /[~!@#$%^&*()_\-+=`{}\[\]|\\:;"'<>.,?\/]+/, 
                                    message: 'must contain at least one special character' }, on: :create
    admin.validates :password, format: { with: /[A-Z]+/, 
                                  message: 'must contain at least one uppercase letter' }, on: :create
    admin.validates :password, format: { with: /[a-z]+/, 
                                  message: 'must contain at least one lowercase letter' }, on: :create
    admin.validates :password, format: { with: /[0-9]+/, 
                                  message: 'must contain at least one number' }, on: :create
  end

  with_options unless: :admin? do |non_admin|
    non_admin.validates :username, presence: true
    non_admin.validates :username, length: { minimum: 3 }
    non_admin.validates :username, length: { maximum: 30 }
    non_admin.validates :username, format: { with: /\A[a-zA-Z0-9_-]+\z/, 
                                              message: 'must only contain letters, number, dashes and underscores' }
    non_admin.validates :username, uniqueness: true
    # "if: Proc.new { encrypted_password_changed? }" so devise does validate for password on email change 
    non_admin.validates :password, length: { minimum: 8 }, if: Proc.new { encrypted_password_changed? }
  end

  validates :subdomain, inclusion: { in: VALID_SUBDOMAINS,
  message: "%{value} is not a valid subdomain" }

  has_many :comments

  attr_writer :login

  def login
    @login || self.username || self.email
  end

  # app/models/user.rb

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    subdomain = conditions[:subdomain] || ''
    if (login = conditions.delete(:login))
      where(conditions).where(["username = :value OR lower(email) = lower(:value) AND subdomain = :subdomain", { :value => login, subdomain: subdomain }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end

  def update_without_password(params, *options)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    
    result = update(params, *options)
    clean_up_passwords
    result
  end

  def destroy
    self.comments.destroy_all
    super
  end

  private

  def devise_mailer
    UserMailer
  end
end
