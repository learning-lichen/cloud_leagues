require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert feedbacks(:guest_feedback).valid?
    assert feedbacks(:user_feedback).valid?
  end

  test "message validations" do
    guest_feedback = feedbacks :guest_feedback
    user_feedback = feedbacks :user_feedback
    
    guest_feedback.message = nil
    user_feedback.message = ''
    
    assert !guest_feedback.valid?
    assert !user_feedback.valid?
  end

  test "category validations" do
    guest_feedback = feedbacks :guest_feedback
    user_feedback = feedbacks :user_feedback

    guest_feedback.category = -1
    user_feedback.category = nil

    assert !guest_feedback.valid?
    assert !user_feedback.valid?
  end

  test "guest accessible attributes" do
    feedback_params = {
      user_id: 1,
      message: 'Hey',
      category: 2
    }
    feedback = Feedback.new feedback_params, as: :guest

    assert_nil feedback.user_id
    assert_equal 'Hey', feedback.message
    assert_equal 2, feedback.category
  end

  test "member accessible attributes" do
    feedback_params = {
      user_id: 1,
      message: 'Hey',
      category: 2
    }
    feedback = Feedback.new feedback_params, as: :member

    assert_equal 1, feedback.user_id
    assert_equal 'Hey', feedback.message
    assert_equal 2, feedback.category
  end

  test "moderator accessible attributes" do
    feedback_params = {
      user_id: 1,
      message: 'Hey',
      category: 2
    }
    feedback = Feedback.new feedback_params, as: :moderator

    assert_equal 1, feedback.user_id
    assert_equal 'Hey', feedback.message
    assert_equal 2, feedback.category
  end

  test "admin accessible attributes" do
    feedback_params = {
      user_id: 1,
      message: 'Hey',
      category: 2
    }
    feedback = Feedback.new feedback_params, as: :admin

    assert_equal 1, feedback.user_id
    assert_equal 'Hey', feedback.message
    assert_equal 2, feedback.category
  end
end
