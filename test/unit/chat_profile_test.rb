require 'test_helper'

class ChatProfileTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert chat_profiles(:default_profile).valid?
    assert chat_profiles(:admin_profile).valid?
    assert chat_profiles(:moderator_profile).valid?
    assert chat_profiles(:other_moderator_profile).valid?
  end

  test "user id validations" do
    default_profile = chat_profiles(:default_profile)
    admin_profile = chat_profiles(:admin_profile)
    default_profile.user_id = admin_profile.user_id

    assert !default_profile.valid?
  end

  test "chat id validations" do
    default_profile = chat_profiles(:default_profile)
    admin_profile = chat_profiles(:admin_profile)
    default_profile.chat_id = admin_profile.chat_id

    assert !default_profile.valid?
  end
end
