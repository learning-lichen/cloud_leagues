require 'test_helper'

class MatchTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert matches(:all_match_one).valid?
    assert matches(:all_match_two).valid?
    assert matches(:master_match_one).valid?
    assert matches(:grand_master_match_one).valid?
  end

  test "tournament id validations" do
    all_match_one = matches(:all_match_one)
    all_match_one.tournament_id = nil

    assert !all_match_one.valid?
  end

  test "best of validations" do
    all_match_one = matches :all_match_one
    all_match_two = matches :all_match_two

    all_match_one.best_of = nil
    all_match_two.best_of = 2

    assert !all_match_one.valid?
    assert !all_match_one.valid?
  end

  test "match player relations validations" do
    all_match_one = matches(:all_match_one)
    new_match = all_match_one.match_player_relations.build

    assert !all_match_one.valid?
  end

  test "winner id validations" do
    all_match_one = matches(:all_match_one)
    gm_match_one = matches(:grand_master_match_one)

    all_match_one.winner_id = -1
    gm_match_one.winner_id = gm_match_one.waiting_players.first.id

    assert !all_match_one.valid?
    assert gm_match_one.valid?
  end

  test "new games cannot be created" do
    new_game = { games_attributes: [{winner_id: 5}] }
    match = matches :all_match_one
   
    old_games_length = match.games.length
    match.update_attributes new_game, as: :member
    match.reload
  
    assert_equal old_games_length, match.games.length
  end

  test "guest accessible attributes" do
    new_match_params = {
      tournament_id: 1,
      winner_id: 2,
      games_attributes: [{id: 10, winner_id: 50}]
    }

    new_match = Match.new new_match_params, as: :guest

    assert_nil new_match.tournament_id
    assert_nil new_match.winner_id
    assert new_match.games.empty?
  end

  test "member accessible attributes" do
    new_match_params = {
      tournament_id: 1,
      winner_id: 2
    }

    update_params = {
      games_attributes: [{id: 1, winner_id: 1}]
    }

    all_match_one = matches :all_match_one
    all_match_one.update_attributes update_params, as: :member
    all_match_one.reload
    new_match = Match.new new_match_params, as: :member

    assert_equal 1, all_match_one.games.where(id: 1).first.winner_id
    assert_nil new_match.tournament_id
    assert_nil new_match.winner_id
  end

  test "moderator accessible attributes" do
    new_match_params = {
      tournament_id: 1,
      winner_id: 2
    }

    update_params = {
      games_attributes: [{id: 1, winner_id: 1}]
    }

    all_match_one = matches :all_match_one
    all_match_one.update_attributes update_params, as: :moderator
    all_match_one.reload
    new_match = Match.new new_match_params, as: :moderator

    assert_equal 1, all_match_one.games.where(id: 1).first.winner_id
    assert_nil new_match.tournament_id
    assert_equal 2, new_match.winner_id
  end

  test "admin accessible attributes" do
    new_match_params = {
      tournament_id: 1,
      winner_id: 2
    }

    update_params = {
      games_attributes: [{id: 1, winner_id: 1}]
    }

    all_match_one = matches :all_match_one
    all_match_one.update_attributes update_params, as: :admin
    all_match_one.reload
    new_match = Match.new new_match_params, as: :admin

    assert_equal 1, all_match_one.games.where(id: 1).first.winner_id
    assert_nil new_match.tournament_id
    assert_equal 2, new_match.winner_id
  end

  test "contested" do
    contested_match = matches :master_match_one
    match = matches :all_match_two

    assert contested_match.contested?
    assert !match.contested?
  end

  test "previous matches" do
    assert matches(:all_match_one).previous_matches.empty?
  end

  test "empty delegation" do
    match = Match.new
    assert match.empty?
    assert !matches(:all_match_one).empty?
  end

  test "bye" do
    assert matches(:master_match_one).bye?
    assert !matches(:all_match_one).bye?
  end
end
