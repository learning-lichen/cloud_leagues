require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert tournaments(:all_tournament).valid?
    assert tournaments(:grand_master_tournament).valid?
  end

  test "league validations" do
    all_tournament = tournaments(:all_tournament)
    gm_tournament = tournaments(:grand_master_tournament)

    all_tournament.league = nil
    gm_tournament.league = -1

    assert !all_tournament.valid?
    assert !gm_tournament.valid?
  end

  test "format validations" do
    all_tournament = tournaments(:all_tournament)
    gm_tournament = tournaments(:grand_master_tournament)

    all_tournament.format = nil
    gm_tournament.format = -1

    assert !all_tournament.valid?
    assert !gm_tournament.valid?
  end

  test "start time validations" do
    all_tournament = tournaments(:all_tournament)
    all_tournament.start_time = nil

    assert !all_tournament.valid?
  end

  test "max players validations" do
    all_tournament = tournaments(:all_tournament)
    all_tournament.max_players = nil

    assert !all_tournament.valid?
  end

  test "guest accessible attributes" do
    tournament_params = {
      league: -1,
      format: -1,
      start_time: Time.now,
      max_players: 100
    }

    new_tournament = Tournament.new tournament_params, as: :guest

    assert_equal 0, new_tournament.league
    assert_equal 0, new_tournament.format
    assert_nil new_tournament.start_time
    assert_equal 20, new_tournament.max_players
  end

  test "member accessible attributes" do
    tournament_params = {
      league: -1,
      format: -1,
      start_time: Time.now,
      max_players: 100
    }

    new_tournament = Tournament.new tournament_params, as: :member

    assert_equal 0, new_tournament.league
    assert_equal 0, new_tournament.format
    assert_nil new_tournament.start_time
    assert_equal 20, new_tournament.max_players
  end

  test "moderator accessible attributes" do
    start_time = Time.now
    tournament_params = {
      league: -1,
      format: -1,
      start_time: start_time,
      max_players: 100
    }
    
    new_tournament = Tournament.new tournament_params, as: :moderator

    assert_equal -1, new_tournament.league
    assert_equal -1, new_tournament.format
    assert_equal start_time, new_tournament.start_time
    assert_equal 100, new_tournament.max_players
  end

  test "admin accessible attributes" do
    start_time = Time.now
    tournament_params = {
      league: -1,
      format: -1,
      start_time: start_time,
      max_players: 100
    }
    
    new_tournament = Tournament.new tournament_params, as: :admin

    assert_equal -1, new_tournament.league
    assert_equal -1, new_tournament.format
    assert_equal start_time, new_tournament.start_time
    assert_equal 100, new_tournament.max_players
  end
end
