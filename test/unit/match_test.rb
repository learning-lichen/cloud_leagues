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

  test "guest accessible attributes" do
    new_match_params = {
      tournament_id: 1,
      player_one_id: 1,
      player_two_id: 2,
      player_one_accepts: true,
      player_two_accepts: true,
      winner: 2,
      contested: true
    }

    new_match = Match.new new_match_params, as: :guest

    assert_nil new_match.tournament_id
    assert_nil new_match.player_one_id
    assert_nil new_match.player_two_id
    assert !new_match.player_one_accepts
    assert !new_match.player_two_accepts
    assert_nil new_match.winner
    assert !new_match.contested
  end

  test "member accessible attributes" do
    new_match_params = {
      tournament_id: 1,
      player_one_id: 1,
      player_two_id: 2,
      player_one_accepts: true,
      player_two_accepts: true,
      winner: 2,
      contested: true
    }

    new_match = Match.new new_match_params, as: :member

    assert_nil new_match.tournament_id
    assert_nil new_match.player_one_id
    assert_nil new_match.player_two_id
    assert !new_match.player_one_accepts
    assert !new_match.player_two_accepts
    assert_nil new_match.winner
    assert !new_match.contested
  end

  test "moderator accessible attributes" do
    new_match_params = {
      tournament_id: 1,
      player_one_id: 1,
      player_two_id: 2,
      player_one_accepts: true,
      player_two_accepts: true,
      winner: 2,
      contested: true
    }

    new_match = Match.new new_match_params, as: :moderator

    assert_equal 1, new_match.tournament_id
    assert_equal 1, new_match.player_one_id
    assert_equal 2, new_match.player_two_id
    assert new_match.player_one_accepts
    assert new_match.player_two_accepts
    assert_equal 2, new_match.winner
    assert new_match.contested
  end

  test "admin accessible attributes" do
    new_match_params = {
      tournament_id: 1,
      player_one_id: 1,
      player_two_id: 2,
      player_one_accepts: true,
      player_two_accepts: true,
      winner: 2,
      contested: true
    }

    new_match = Match.new new_match_params, as: :admin

    assert_equal 1, new_match.tournament_id
    assert_equal 1, new_match.player_one_id
    assert_equal 2, new_match.player_two_id
    assert new_match.player_one_accepts
    assert new_match.player_two_accepts
    assert_equal 2, new_match.winner
    assert new_match.contested
  end
end
