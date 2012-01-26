require 'test_helper'

class HomeControllerTest < ActionController::TestCase  
  test "should get index for guest" do
    get :index

    assert_response :success
  end

  test "should get index for member" do
    default_user = login :default_user
    get :index
    
    assert default_user.role? :member
    assert_response :success
  end

  test "should get index for moderator" do
    moderator_user = login :moderator_user
    get :index
    
    assert moderator_user.role? :moderator
    assert_response :success
  end
  
  test "should get index for admin" do
    admin_user = login :admin_user
    get :index

    assert admin_user.role? :admin
    assert_response :success
  end
end
