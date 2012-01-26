require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index

    assert_response :success
  end

  test "should get new" do
    get :new
    
    assert_response :success
  end
  
  test "shoud create user" do
    assert_difference 'User.count' do 
      post :create, :user => {:login => 'new_user', :email => 'new@new.com',
        :password => 'new_password', :password_confirmation => 'new_password'}
    end
    
    assert user_session = UserSession.find
    assert_redirected_to user_path(user_session.user)
  end

  test "should show user" do
    default_user = users(:default_user)
    get :show, :id => default_user.id

    assert_response :success
  end

  test "should get edit" do
    default_user = login :default_user
    get :edit, :id => default_user.id

    assert_response :success
  end

  test "should update user" do
    default_user = login :default_user
    put :update, :id => default_user.id, :user => {:email => 'new@new.com'}
    default_user = User.find default_user.id

    assert_redirected_to user_path(default_user)
    assert_equal 'new@new.com', default_user.email
  end

  test "should not update other user" do
    other_user = login :other_user
    default_user = users(:default_user)
    put :update, :id => default_user.id, :user => {:email => 'new@new.com'}
    default_user.reload

    assert_redirected_to root_path
    assert_not_equal 'new@new.com', default_user.email
  end

  test "should delete user" do
    default_user = login :default_user
    delete :destroy, :id => default_user.id
    
    assert_nil User.find_by_id(default_user.id)
    assert_redirected_to root_path
  end

  test "should not delete user" do
    other_user = login :other_user
    default_user = users(:default_user)
    delete :destroy, :id => default_user.id
    
    assert_not_nil User.find_by_id(default_user.id)
    assert_redirected_to root_path
  end
end
