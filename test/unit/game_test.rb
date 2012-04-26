require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert games(:all_match_one_game_one).valid?
    assert games(:grand_master_match_one_game_one).valid?
    assert games(:all_match_two_game_one).valid?
    assert games(:master_match_one_game_one).valid?
  end

  test "match id validations" do
    all_m1g1 = games :all_match_one_game_one
    all_m1g1.match_id = nil

    assert !all_m1g1.valid?
  end

  test "winner id validations" do
    all_m1g1 = games :all_match_one_game_one
    gm_m1g1 = games :grand_master_match_one_game_one

    all_m1g1.winner_id = -1
    gm_m1g1.winner_id = gm_m1g1.match.waiting_players.first.id

    assert !all_m1g1.valid?
    assert gm_m1g1.valid?
  end

  test "guest accessible attributes" do
    new_game_params = {
      match_id: 1,
      winner_id: 2
    }

    new_game = Game.new new_game_params, as: :guest

    assert_nil new_game.match_id
    assert_nil new_game.winner_id
  end

  test "member accessible attributes" do
    new_game_params = {
      match_id: 1,
      winner_id: 2
    }

    new_game = Game.new new_game_params, as: :member

    assert_nil new_game.match_id
    assert_equal 2, new_game.winner_id
  end

  test "moderator accessible attributes" do
    new_game_params = {
      match_id: 1,
      winner_id: 2
    }

    new_game = Game.new new_game_params, as: :moderator

    assert_nil new_game.match_id
    assert_equal 2, new_game.winner_id
  end

  test "admin accessible attributes" do
    new_game_params = {
      match_id: 1,
      winner_id: 2
    }

    new_game = Game.new new_game_params, as: :admin

    assert_nil new_game.match_id
    assert_equal 2, new_game.winner_id
  end
end
