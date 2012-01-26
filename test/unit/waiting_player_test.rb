require 'test_helper'

class WaitingPlayerTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert waiting_players(:default_waiting_all).valid?
    assert waiting_players(:admin_waiting_grand_master).valid?
  end
end
