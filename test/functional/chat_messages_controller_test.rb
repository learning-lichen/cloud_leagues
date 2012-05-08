require 'test_helper'

class ChatMessagesControllerTest < ActionController::TestCase
  test "should not get index" do
    login :other_user
    get :index, user_id: users(:default_user).id
    
    assert_redirected_to root_path
  end

  test "should get index" do
    user = login :default_user
    get :index, user_id: user.id
    
    assert_response :success
  end

  test "should not show message" do
    login :other_user
    user = users :default_user
    message = chat_messages :admin_to_default
    get :show, user_id: user.id, id: message.id

    assert_redirected_to root_path
  end

  test "should show message" do
    user = login :default_user
    message = chat_messages :admin_to_default
    get :show, user_id: user.id, id: message.id

    assert_response :success
  end

  test "should not get new" do
    login :other_user
    get :new, user_id: users(:default_user).id
    
    assert_redirected_to root_path
  end

  test "should get new" do
    user = login :default_user
    get :new, user_id: user.id

    assert_response :success
  end

  test "should not create message" do
    login :other_user
    user = users(:default_user)
    recipient_id = users(:admin_user).chat_profile.id
    sender_id = user.chat_profile.id
    message = "hello"
    params = { recipient_id: recipient_id, sender_id: sender_id, 
      message: message }

    assert_no_difference 'ChatMessage.count' do
      post :create, user_id: user.id, chat_message: params
    end
    assert_redirected_to root_path
  end

  test "should create message" do
    user = login :default_user
    message = 'hello'

    assert_difference 'ChatMessage.count' do
      post :create, user_id: user.id, chat_message: { recipient_id: users(:admin_user).login, 
        sender_id: user.chat_profile.chat_id, message: message }
    end
  end

  test "should not destroy message" do
    login :other_user
    user = users :default_user
    message = chat_messages :default_to_admin
    
    assert_no_difference 'ChatMessage.count' do
      delete :destroy, user_id: user.id, id: message.id
    end
    assert_redirected_to root_path
  end

  test "should destroy message" do
    user = login :default_user
    message = chat_messages :admin_to_default

    assert_difference 'ChatMessage.count', -1 do
      delete :destroy, user_id: user.id, id: message.id
    end
    assert_redirected_to user_chat_messages_path(user)
  end
end
