require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should get new for guest" do
    get :new
    assert_response :success
  end

  test "should redirect new for member" do
    default_user = login :default_user
    get :new

    assert default_user.role? :member
    assert_redirected_to root_path
  end

  test "should redirect new for moderator" do
    moderator_user = login :moderator_user
    get :new

    assert moderator_user.role? :moderator
    assert_redirected_to root_path
  end

  test "should get new for admin" do
    admin_user = login :admin_user
    get :new

    assert_response :success
  end
  
  test "should create user session for guest" do
    default_user = users(:default_user)
    post :create, :user_session => {:login => 'Default_User', 
      :password => 'default_password'}
    
    assert user_session = UserSession.find
    assert_equal default_user, user_session.user
    assert_redirected_to user_path(default_user)
  end

  test "should redirect destroy for guest" do
    delete :destroy

    assert_redirected_to login_path
  end

  test "should destroy for member" do
    default_user = login :default_user
    delete :destroy

    assert_nil UserSession.find
    assert_redirected_to root_path
  end

  test "should destroy for moderator" do
    moderator_user = login :moderator_user
    delete :destroy

    assert_nil UserSession.find
    assert_redirected_to root_path
  end

  test "should destroy for admin" do
    admin_user = login :admin_user
    delete :destroy
    
    assert_nil UserSession.find
    assert_redirected_to root_path
  end
end
