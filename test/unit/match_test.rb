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
    gm_match_one.winner_id = gm_match_one.waiting_players.first.user.id

    assert !all_match_one.valid?
    assert gm_match_one.valid?
  end

  test "guest accessible attributes" do
    new_match_params = {
      tournament_id: 1,
      winner_id: 2
    }

    new_match = Match.new new_match_params, as: :guest

    assert_nil new_match.tournament_id
    assert_nil new_match.winner_id
  end

  test "member accessible attributes" do
    new_match_params = {
      tournament_id: 1,
      winner_id: 2
    }

    new_match = Match.new new_match_params, as: :member

    assert_nil new_match.tournament_id
    assert_equal 2, new_match.winner_id
  end

  test "moderator accessible attributes" do
    new_match_params = {
      tournament_id: 1,
      winner_id: 2
    }

    new_match = Match.new new_match_params, as: :moderator

    assert_nil new_match.tournament_id
    assert_equal 2, new_match.winner_id
  end

  test "admin accessible attributes" do
    new_match_params = {
      tournament_id: 1,
      winner_id: 2
    }

    new_match = Match.new new_match_params, as: :admin

    assert_nil new_match.tournament_id
    assert_equal 2, new_match.winner_id
  end
end
