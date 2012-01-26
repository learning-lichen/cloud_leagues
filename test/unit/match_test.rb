require 'test_helper'

class MatchTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert matches(:all_match_one).valid?
    assert matches(:grand_master_match_one).valid?
  end

  test "tournament id validations" do
    all_match_one = matches(:all_match_one)
    all_match_one.tournament_id = nil

    assert !all_match_one.valid?
  end

  test "player one id validations" do
    all_match_one = matches(:all_match_one)
    all_match_one.player_one_id = nil

    assert !all_match_one.valid?
  end

  test "player two id validations" do
    all_match_one = matches(:all_match_one)
    all_match_one.player_two_id = nil
    
    assert !all_match_one.valid?
  end
end
