require 'test_helper'

class ChatMessageTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert chat_messages(:default_to_admin).valid?
    assert chat_messages(:admin_to_default).valid?
    assert chat_messages(:admin_to_mod).valid?
  end

  test "sender id validations" do
    default_to_admin = chat_messages(:default_to_admin)
    default_to_admin.sender_id = nil

    assert !default_to_admin.valid?
  end

  test "recipient id validations" do
    default_to_admin = chat_messages(:default_to_admin)
    default_to_admin.recipient_id = nil

    assert !default_to_admin.valid?
  end

  test "message validations" do
    default_to_admin = chat_messages(:default_to_admin)
    default_to_admin.message = nil

    assert !default_to_admin.valid?
  end

  test "strip inputs" do
    default_to_admin = chat_messages(:default_to_admin)
    default_to_admin.message = '   hello    '
    default_to_admin.save
    default_to_admin.reload

    assert_equal 'hello', default_to_admin.message
  end
end
