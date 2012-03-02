require 'test_helper'

class AccountInformationTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert account_informations(:default_information).valid?
    assert account_informations(:admin_information).valid?
    assert account_informations(:mod_information).valid?
    assert account_informations(:other_mod_information).valid?
  end

  test "user id validations" do
    default_information = account_informations(:default_information)
    admin_information = account_informations(:admin_information)

    admin_information.user_id = 1

    assert !admin_information.valid?
  end

  test "reddit name validations" do
    default_information = account_informations(:default_information)
    admin_information = account_informations(:admin_information)

    admin_information.reddit_name = default_information.reddit_name
    default_information.reddit_name = nil

    assert default_information.valid?
    assert !admin_information.valid?
  end

  test "character name validations" do
    default_information = account_informations(:default_information)
    admin_information = account_informations(:admin_information)
    
    default_information.character_name = admin_information.character_name
    default_information.character_code = admin_information.character_code
    admin_information.character_name = 'new name'
    
    assert !default_information.valid?
    assert admin_information.valid?
  end

  test "character code validations" do
    default_information = account_informations(:default_information)
    admin_information = account_informations(:default_information)
    mod_information = account_informations(:mod_information)
    
    default_information.character_code = nil
    admin_information.character_code = 'abc'
    mod_information.character_code = '1234'

    assert !default_information.valid?
    assert !admin_information.valid?
    assert !mod_information.valid?
  end

  test "role validations" do
    default_information = account_informations(:default_information)
    default_information.role = 10

    assert !default_information.valid?
  end

  test "race validations" do
    default_information = account_informations(:default_information)
    default_information.race = -1

    assert !default_information.valid?
  end

  test "league validations" do
    default_information = account_informations(:default_information)
    admin_information =  account_informations(:admin_information)
    mod_information = account_informations(:mod_information)
  
    default_information.league = nil
    admin_information.league = -1
    mod_information.league = Tournament::ALL

    assert !default_information.valid?
    assert !admin_information.valid?
    assert !mod_information.valid?
  end

  test "time zone validations" do
    default_information = account_informations(:default_information)
    admin_information = account_informations(:admin_information)

    default_information.time_zone = nil
    admin_information.time_zone = 'garbage'

    assert !default_information.valid?
    assert !admin_information.valid?
  end

  test "guest accessible attributes" do
    account_information_params = {
      user_id: 1,
      reddit_name: 'hello',
      character_name: 'char_name',
      character_code: 555,
      role: 2,
      race: -1,
      league: -1,
      time_zone: 'hey'
    }

    new_info = AccountInformation.new account_information_params, as: :guest

    assert_nil new_info.user_id
    assert_nil new_info.reddit_name
    assert_nil new_info.character_name
    assert_nil new_info.character_code
    assert_equal 0, new_info.role
    assert_nil new_info.race
    assert_nil new_info.league
    assert_nil new_info.time_zone
  end

  test "new member accessible attributes" do
    account_info_params = {
      user_id: 1,
      reddit_name: 'hello',
      character_name: 'char_name',
      character_code: 555,
      role: 2,
      race: 2,
      league: 5,
      time_zone: 'hey'
    }

    new_info = AccountInformation.new account_info_params, as: :new_member

    assert_nil new_info.user_id
    assert_equal 'hello', new_info.reddit_name
    assert_equal 'char_name', new_info.character_name
    assert_equal 555, new_info.character_code
    assert_equal 0, new_info.role
    assert_equal 2, new_info.race
    assert_equal 5, new_info.league
    assert_equal 'hey', new_info.time_zone
  end

  test "member accessible attributes" do
    account_information_params = {
      user_id: 1,
      reddit_name: 'hello',
      character_name: 'char_name',
      character_code: 555,
      role: 2,
      race: 2,
      league: 5,
      time_zone: 'hey'
    }

    new_info = AccountInformation.new account_information_params, as: :member

    assert_nil new_info.user_id
    assert_equal 'hello', new_info.reddit_name
    assert_nil new_info.character_name
    assert_nil new_info.character_code
    assert_equal 0, new_info.role
    assert_equal 2, new_info.race
    assert_nil new_info.league
    assert_equal 'hey', new_info.time_zone
  end

  test "moderator accessible attributes" do
    account_info_params = {
      user_id: 1,
      reddit_name: 'hello',
      character_name: 'char_name',
      character_code: 555,
      role: 2,
      race: 2,
      league: 5,
      time_zone: 'hey'
    }

    new_info = AccountInformation.new account_info_params, as: :moderator

    assert_nil new_info.user_id
    assert_equal 'hello', new_info.reddit_name
    assert_equal 'char_name', new_info.character_name
    assert_equal 555, new_info.character_code
    assert_equal 0, new_info.role
    assert_equal 2, new_info.race
    assert_equal 5, new_info.league
    assert_equal 'hey', new_info.time_zone
  end

  test "admin accessible attributes" do
    account_info_params = {
      user_id: 1,
      reddit_name: 'hello',
      character_name: 'char_name',
      character_code: 555,
      role: 2,
      race: 2,
      league: 5,
      time_zone: 'hey'
    }

    new_info = AccountInformation.new account_info_params, as: :admin

    assert_equal 1, new_info.user_id
    assert_equal 'hello', new_info.reddit_name
    assert_equal 'char_name', new_info.character_name
    assert_equal 555, new_info.character_code
    assert_equal 2, new_info.role
    assert_equal 2, new_info.race
    assert_equal 5, new_info.league
    assert_equal 'hey', new_info.time_zone
  end

  test "strip inputs" do
    admin_information = account_informations(:admin_information)

    admin_information.reddit_name = ' test name '
    admin_information.character_name = ' test character name '
    admin_information.character_code = ' 999 '
    admin_information.save
    admin_information.reload

    assert_equal 'test name', admin_information.reddit_name
    assert_equal 'test character name', admin_information.character_name
    assert_equal '999', admin_information.character_code
  end
end
