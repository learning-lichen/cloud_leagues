require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "guest accessible attributes" do
    new_user_params = {
      login: 'new_user',
      email: 'new@new.com',
      password: 'new_password',
      password_confirmation: 'new_password'
    }

    new_user = User.new new_user_params, :as => :guest
    new_user.save
    new_user.reload

    assert_equal 'new_user', new_user.login
    assert_equal 'new@new.com', new_user.email
  end

  test "member accessible attributes" do
    updated_user_params = {
      login: 'new_login',
      email: 'new_email@new.com',
      password: 'new_password',
      password_confirmation: 'new_password'
    }

    default_user = users(:default_user)
    role = default_user.role
    old_login = default_user.login
    default_user.update_attributes updated_user_params, :as => role
    default_user.save
    default_user.reload

    assert_equal old_login, default_user.login
    assert_equal 'new_email@new.com', default_user.email
  end

  test "moderator accessible attributes" do
    updated_user_params = {
      login: 'new_login',
      email: 'new_email@new.com',
      password: 'new_password',
      password_confirmation: 'new_password'
    }
    
    moderator_user = users(:moderator_user)
    role = moderator_user.role
    old_login = moderator_user.login
    moderator_user.update_attributes updated_user_params, :as => role
    moderator_user.save
    moderator_user.reload
    
    assert_equal old_login, moderator_user.login
    assert_equal 'new_email@new.com', moderator_user.email
  end

  test "admin accessible attributes" do
    updated_user_params = {
      login: 'new_login',
      email: 'new_email@new.com',
      password: 'new_password',
      password_confirmation: 'new_password'
    }

    default_user = users(:default_user)
    role = :admin
    default_user.update_attributes updated_user_params, :as => role
    default_user.save
    default_user.reload

    assert_equal 'new_login', default_user.login
    assert_equal 'new_email@new.com', default_user.email
  end

  test "returned role" do
    default_user = users(:default_user)
    other_user = users(:other_user)
    admin_user = users(:admin_user)
    moderator_user = users(:moderator_user)
    guest_user = User.new

    assert_equal :member, default_user.role
    assert_equal :member, other_user.role
    assert_equal :admin, admin_user.role
    assert_equal :moderator, moderator_user.role
    assert_equal :guest, guest_user.role
  end

  test "role recognition" do
    default_user = users(:default_user)
    other_user = users(:other_user)
    admin_user = users(:admin_user)
    moderator_user = users(:moderator_user)
    guest_user = User.new

    assert !default_user.role?(:guest)
    assert default_user.role?(:member)
    assert !default_user.role?(:moderator)
    assert !default_user.role?(:admin)
   
    assert !other_user.role?(:guest)
    assert other_user.role?(:member)
    assert !other_user.role?(:moderator)
    assert !other_user.role?(:admin)

    assert !admin_user.role?(:guest)
    assert !admin_user.role?(:member)
    assert !admin_user.role?(:moderator)
    assert admin_user.role?(:admin)
    
    assert !moderator_user.role?(:guest)
    assert !moderator_user.role?(:member)
    assert moderator_user.role?(:moderator)
    assert !moderator_user.role?(:admin)
  
    assert guest_user.role?(:guest)
    assert !guest_user.role?(:member)
    assert !guest_user.role?(:moderator)
    assert !guest_user.role?(:admin)
  end

  test "strip inputs" do
    default_user = users(:default_user)
    default_user.login = '    login    '
    default_user.email = '   email@email.com   '
    default_user.save
    default_user.reload

    assert_equal 'login', default_user.login
    assert_equal 'email@email.com', default_user.email
  end
end
