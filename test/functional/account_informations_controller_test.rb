require 'test_helper'

class AccountInformationsControllerTest < ActionController::TestCase
  test "should get new" do
    other_user = login :other_user
    get :new, user_id: other_user.id
    
    assert_response :success
  end

  test "should create account information" do
    other_user = login :other_user
    assert_difference ['AccountInformation.count', 'ChatProfile.count'] do
      post :create, user_id: other_user.id, account_information: {
        reddit_name: 'other user', character_name: 'other char',
        character_code: 555, race: 0, league: Tournament::DIAMOND,
        time_zone: ActiveSupport::TimeZone.us_zones.first.name.dup }
    end

    new_info = other_user.account_information

    assert_equal 'other user', new_info.reddit_name
    assert_equal 'other char', new_info.character_name
    assert_equal '555', new_info.character_code
  end

  test "should show account information" do
    get :show, user_id: users(:default_user).id

    assert_response :success
  end

  test "should get edit" do
    login :moderator_user
    get :edit, user_id: users(:default_user).id

    assert_response :success
  end

  test "should update account information" do
    login :moderator_user
    default_information = account_informations(:default_information)
    put :update, user_id: default_information.user_id, account_information: { 
      reddit_name: 'velium' }

    default_information.reload

    assert_redirected_to user_profile_path(default_information.user)
    assert_equal 'velium', default_information.reddit_name
  end

  test "should not update account information" do
    default_user = login :default_user
    admin_user = users(:admin_user)
    admin_information = admin_user.account_information
    old_name = admin_information.reddit_name
    put :update, user_id: admin_user.id, account_information: {
      reddit_name: 'new_name' }

    admin_information.reload

    assert_redirected_to root_path
    assert_equal old_name, admin_information.reddit_name
  end

  test "should delete account information" do
    login :moderator_user
    default_user = users(:default_user)
    delete :destroy, user_id: default_user.id

    assert_nil default_user.account_information
    assert_redirected_to user_path(default_user)
  end

  test "should not delete account information" do
    default_user = login :default_user
    delete :destroy, user_id: default_user.id

    assert_not_nil default_user.account_information
    assert_redirected_to root_path
  end
end
