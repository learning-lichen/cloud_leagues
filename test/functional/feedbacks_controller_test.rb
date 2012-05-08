require 'test_helper'

class FeedbacksControllerTest < ActionController::TestCase
  test "should submit feedback" do
    user = login :default_user
    feedback_params = {
      user_id: user.id,
      message: 'Hello',
      category: 0
    }

    assert_difference 'Feedback.count' do
      post :create, feedback: feedback_params
    end
  end

  test "should submit anonamous feedback" do
    user = users :default_user
    feedback_params = {
      user_id: user.id,
      message: 'gogogo',
      category: 0
    }

    assert_difference 'Feedback.count' do
      post :create, feedback: feedback_params
    end
    assert Feedback.find_by_message('gogogo').user_id.nil?
  end

  test "should not submit feedback" do
    login :default_user
    user = users :other_user
    feedback_params = {
      user_id: user.id,
      message: 'gogogo',
      category: 0
    }

    assert_no_difference 'Feedback.count' do
      post :create, feedback: feedback_params
    end
  end
end
