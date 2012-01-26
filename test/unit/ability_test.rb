require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  ##############################################################################
  # User Modification Abilities                                                #
  ##############################################################################
  test "guest can read users" do
    ability = Ability.new(nil)

    assert ability.can?(:read, users(:default_user))
    assert ability.can?(:read, users(:admin_user))
    assert ability.can?(:read, users(:moderator_user))
  end

  test "guest can create user" do
    ability = Ability.new(nil)

    assert ability.can?(:create, User.new)
  end

  test "guest cannot update users" do
    ability = Ability.new(nil)

    assert ability.cannot?(:update, users(:default_user))
    assert ability.cannot?(:update, users(:admin_user))
    assert ability.cannot?(:update, users(:moderator_user))
  end

  test "guest cannot destroy users" do
    ability = Ability.new(nil)

    assert ability.cannot?(:destroy, users(:default_user))
    assert ability.cannot?(:destroy, users(:admin_user))
    assert ability.cannot?(:destroy, users(:moderator_user))
  end

  test "member can read users" do
    ability = Ability.new(users(:default_user))

    assert ability.can?(:read, users(:default_user))
    assert ability.can?(:read, users(:other_user))
    assert ability.can?(:read, users(:admin_user))
    assert ability.can?(:read, users(:moderator_user))
  end

  test "member cannot create user" do
    ability = Ability.new(users(:default_user))

    assert ability.cannot?(:create, User.new)
  end

  test "member can only update self" do
    ability = Ability.new(users(:default_user))

    assert ability.can?(:update, users(:default_user))
    assert ability.cannot?(:update, users(:other_user))
    assert ability.cannot?(:update, users(:admin_user))
    assert ability.cannot?(:update, users(:moderator_user))
  end

  test "member can only destroy self" do
    ability = Ability.new(users(:default_user))

    assert ability.can?(:destroy, users(:default_user))
    assert ability.cannot?(:destroy, users(:other_user))
    assert ability.cannot?(:destroy, users(:admin_user))
    assert ability.cannot?(:destroy, users(:moderator_user))
  end

  test "moderator can read users" do
    ability = Ability.new(users(:moderator_user))

    assert ability.can?(:read, users(:default_user))
    assert ability.can?(:read, users(:admin_user))
    assert ability.can?(:read, users(:moderator_user))
  end

  test "moderator cannot create user" do
    ability = Ability.new(users(:moderator_user))

    assert ability.cannot?(:create, User.new)
  end

  test "moderator can update members" do
    ability = Ability.new(users(:moderator_user))

    assert ability.can?(:update, users(:default_user))
    assert ability.can?(:update, users(:moderator_user))
    assert ability.cannot?(:update, users(:other_moderator_user))
    assert ability.cannot?(:update, users(:admin_user))
  end

  test "moderator can only destroy self" do
    ability = Ability.new(users(:moderator_user))

    assert ability.cannot?(:destroy, users(:default_user))
    assert ability.can?(:destroy, users(:moderator_user))
    assert ability.cannot?(:destroy, users(:other_moderator_user))
    assert ability.cannot?(:destroy, users(:admin_user))
  end

  test "admin can read users" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:read, users(:default_user))
    assert ability.can?(:read, users(:admin_user))
    assert ability.can?(:read, users(:moderator_user))
  end

  test "admin can create user" do
    ability = Ability.new(users(:admin_user))

    ability.can?(:create, User.new)
  end

  test "admin can update all users" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:update, users(:default_user))
    assert ability.can?(:update, users(:moderator_user))
    assert ability.can?(:update, users(:admin_user))
  end

  test "admin can destroy all users" do
    ability = Ability.new(users(:admin_user))
    
    assert ability.can?(:destroy, users(:default_user))
    assert ability.can?(:destroy, users(:moderator_user))
    assert ability.can?(:destroy, users(:admin_user))
  end

  ##############################################################################
  # Account Information Modification Abilities                                 #
  ##############################################################################
  test "guests can read account information" do
    ability = Ability.new(nil)

    assert ability.can?(:read, account_informations(:default_information))
    assert ability.can?(:read, account_informations(:mod_information))
    assert ability.can?(:read, account_informations(:admin_information))
  end

  test "guests cannot create account information" do
    ability = Ability.new(nil)

    assert ability.cannot?(:create, AccountInformation.new)
  end

  test "guests cannot update account information" do
    ability = Ability.new(nil)

    assert ability.cannot?(:update, account_informations(:default_information))
    assert ability.cannot?(:update, account_informations(:mod_information))
    assert ability.cannot?(:update, account_informations(:admin_information))
  end

  test "guests cannot destroy account information" do
    ability = Ability.new(nil)
    
    assert ability.cannot?(:destroy, account_informations(:default_information))
    assert ability.cannot?(:destroy, account_informations(:mod_information))
    assert ability.cannot?(:destroy, account_informations(:admin_information))
  end

  test "members can read accout information" do
    ability = Ability.new(users(:default_user))

    assert ability.can?(:read, account_informations(:default_information))
    assert ability.can?(:read, account_informations(:mod_information))
    assert ability.can?(:read, account_informations(:admin_information))
  end

  test "members can create one account information" do
    default_ability = Ability.new(users(:default_user))
    other_ability = Ability.new(users(:other_user))

    default_ability.cannot?(:create, AccountInformation.new)
    other_ability.can?(:create, AccountInformation.new)
  end

  test "members cannot update account information" do
    ability = Ability.new(users(:default_user))

    assert ability.cannot?(:update, account_informations(:default_information))
    assert ability.cannot?(:update, account_informations(:mod_information))
    assert ability.cannot?(:update, account_informations(:admin_information))
  end

  test "members cannot destroy account information" do
    ability = Ability.new(users(:default_user))

    assert ability.cannot?(:destroy, account_informations(:default_information))
    assert ability.cannot?(:destroy, account_informations(:mod_information))
    assert ability.cannot?(:destroy, account_informations(:admin_information))
  end

  test "moderators can read account information" do
    ability = Ability.new(users(:moderator_user))

    assert ability.can?(:read, account_informations(:default_information))
    assert ability.can?(:read, account_informations(:mod_information))
    assert ability.can?(:read, account_informations(:admin_information))
  end

  test "moderators can create account information for members" do
    ability = Ability.new(users(:moderator_user))
    other_user = users(:other_user)

    assert ability.can?(:create, other_user.build_account_information)
  end

  test "moderators can update account information for members" do
    ability = Ability.new(users(:moderator_user))

    assert ability.can?(:update, account_informations(:default_information))
    assert ability.can?(:update, account_informations(:mod_information))
    assert ability.cannot?(:update, account_informations(:other_mod_information))
    assert ability.cannot?(:update, account_informations(:admin_information))
  end

  test "moderators can destroy account information for members" do
    ability = Ability.new(users(:moderator_user))

    assert ability.can?(:destroy, account_informations(:default_information))
    assert ability.can?(:destroy, account_informations(:mod_information))
    assert ability.cannot?(:destroy, account_informations(:other_mod_information))
    assert ability.cannot?(:destroy, account_informations(:admin_information))
  end

  test "admin can read account information" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:read, account_informations(:default_information))
    assert ability.can?(:read, account_informations(:mod_information))
    assert ability.can?(:read, account_informations(:admin_information))
  end

  test "admins can create account information for users" do
    ability = Ability.new(users(:admin_user))
    default_id = users(:default_user).id
    admin_id = users(:admin_user).id
    mod_id = users(:moderator_user).id
    o_mod_id = users(:other_moderator_user).id
    
    assert ability.can?(:create, AccountInformation.new(:user_id => default_id))
    assert ability.can?(:create, AccountInformation.new(:user_id => mod_id))
    assert ability.can?(:create, AccountInformation.new(:user_id => admin_id))
    assert ability.can?(:create, AccountInformation.new(:user_id => o_mod_id))
  end

  test "admins can update account information for users" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:update, account_informations(:default_information))
    assert ability.can?(:update, account_informations(:mod_information))
    assert ability.can?(:update, account_informations(:other_mod_information))
    assert ability.can?(:update, account_informations(:admin_information))
  end

  test "admins can destroy account information for users" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:destroy, account_informations(:default_information))
    assert ability.can?(:destroy, account_informations(:mod_information))
    assert ability.can?(:destroy, account_informations(:other_mod_information))
    assert ability.can?(:destroy, account_informations(:admin_information))
  end
end
