require 'test_helper'

class WaitingPlayerTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert waiting_players(:default_waiting_all).valid?
    assert waiting_players(:admin_waiting_grand_master).valid?
    assert waiting_players(:admin_waiting_all).valid?
    assert waiting_players(:mod_waiting_all).valid?
    assert waiting_players(:default_waiting_grand_master).valid?
  end
  
  test "tournament id validations" do
    default_waiting_all = waiting_players(:default_waiting_all)
    default_waiting_all.tournament_id = nil

    assert !default_waiting_all.valid?
  end

  test "user id validations" do
    default_waiting_all = waiting_players(:default_waiting_all)
    admin_waiting_all = waiting_players(:admin_waiting_all)
    admin_waiting_all.user_id = default_waiting_all.user_id

    assert !admin_waiting_all.valid?
  end
  
  test "guest accessible attributes" do
    waiting_player_params = {
      tournament_id: -1,
      user_id: -1,
      player_accepted: true
    }

    new_waiting_player = WaitingPlayer.new waiting_player_params, as: :guest

    assert_nil new_waiting_player.tournament_id
    assert_nil new_waiting_player.user_id
    assert !new_waiting_player.player_accepted
  end

  test "member accessible attributes" do
    waiting_player_params = {
      tournament_id: -1,
      user_id: -1,
      player_accepted: true
    }

    new_waiting_player = WaitingPlayer.new waiting_player_params, as: :member

    assert_nil new_waiting_player.tournament_id
    assert_nil new_waiting_player.user_id
    assert !new_waiting_player.player_accepted
  end

  test "moderator accessible attributes" do
    waiting_player_params = {
      tournament_id: -1,
      user_id: -1,
      player_accepted: true
    }

    new_waiting_player = WaitingPlayer.new waiting_player_params, as: :moderator

    assert_nil new_waiting_player.tournament_id
    assert_nil new_waiting_player.user_id
    assert new_waiting_player.player_accepted
  end

  test "admin accessible attributes" do
    waiting_player_params = {
      tournament_id: -1,
      user_id: -1,
      player_accepted: true
    }

    new_waiting_player = WaitingPlayer.new waiting_player_params, as: :admin

    assert_equal -1, new_waiting_player.tournament_id
    assert_equal -1, new_waiting_player.user_id
    assert new_waiting_player.player_accepted
  end
end
