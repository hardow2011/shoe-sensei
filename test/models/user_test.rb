require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'non-admin user must have a username' do
    user = User.new(email: 'user@email.com',  password: 'P@tito-f3o')
    user.save

    refute user.admin?, 'user default value for admin should be false'

    refute user.valid?

    assert_not_empty user.errors[:username], 'no validation errors for non-admin user with no username'

    user.username = 'mynewuser'

    user.save
    assert user.valid?
  end

  test 'admin user cannot have a username' do
    user = User.new(email: 'user@email.com', username: 'randomusername', password: 'P@tito-f3o', admin: true)
    user.save
    refute user.valid?

    assert_not_empty user.errors[:username], 'admin user cannnot have a username'

    user.username = nil

    user.save
    assert user.valid?
  end

  test 'non-admin user username should be well formatted' do
    user = User.new(email: 'user@email.com',  password: 'P@tito-f3o', username: '')
    user.save
    # Check username blank and length
    refute user.valid?
    assert_includes user.errors[:username], "can't be blank"
    assert_includes user.errors[:username], "is too short (minimum is 3 characters)"

    user.username = 'ol'
    user.save
    refute user.valid?
    assert_not_includes user.errors[:username], "can't be blank"
    assert_includes user.errors[:username], "is too short (minimum is 3 characters)"

    user.username = 'ol 8'
    user.save
    # Check username alpha-numeric, dashes and underscore format
    refute user.valid?
    assert_includes user.errors[:username], "must only contain letters, number, dashes or underscores"

    too_long_username = ''
    30.times { |i| too_long_username << "#{i}" }

    user.username = too_long_username
    user.save
    # Check username length
    refute user.valid?
    assert_includes user.errors[:username], "is too long (maximum is 30 characters)"

    user.username = 'ol8'
    user.save
    assert user.valid?
    assert_not_includes user.errors[:username], "can't be blank"
    assert_not_includes user.errors[:username], "is too short (minimum is 3 characters)"

    new_user = User.new(email: 'anoteruser@email.com',  password: '123456', username: 'ol8')
    new_user.save
    refute new_user.valid?
    assert_not_includes new_user.errors[:username], "must be unique"
  end

  test 'password should be well formatted' do
    user = User.new(email: 'admin@email.com',  password: '', username: 'ol8')
    user.save
    refute user.valid?
    # Check password blank and length
    assert_includes user.errors[:password], "can't be blank"
    assert_includes user.errors[:password], "is too short (minimum is 8 characters)"

    user.password = '1234567'
    user.save
    refute user.valid?
    assert_not_includes user.errors[:password], "can't be blank"
    assert_includes user.errors[:password], "is too short (minimum is 8 characters)"
    assert_not_includes user.errors[:password], "must contain at least one number"
    assert_includes user.errors[:password], "must contain at least one special character"
    assert_not_includes user.errors[:password], "must contain at least one number"
    assert_includes user.errors[:password], "must contain at least one lowercase letter"
    assert_includes user.errors[:password], "must contain at least one uppercase letter"

    user.password = 'Patito-feo'
    user.save
    refute user.valid?
    assert_not_includes user.errors[:password], "can't be blank"
    assert_not_includes user.errors[:password], "is too short (minimum is 8 characters)"
    assert_includes user.errors[:password], "must contain at least one number"
    assert_not_includes user.errors[:password], "must contain at least one special character"
    assert_includes user.errors[:password], "must contain at least one number"
    assert_not_includes user.errors[:password], "must contain at least one lowercase letter"
    assert_not_includes user.errors[:password], "must contain at least one uppercase letter"

    user.password = 'P@tito-f3o'
    user.save
    assert user.valid?
  end
end
