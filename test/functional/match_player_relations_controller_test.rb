require 'test_helper'

class MatchPlayerRelationsControllerTest < ActionController::TestCase
  test "should update match player relation" do
    login :default_user
    t = tournaments :all_tournament
    m = matches :all_match_one
    mpr = match_player_relations :default_all_match_one
    old_contested = mpr.contested

    put :update, tournament_id: t.id, match_id: m.id, id: mpr.id, match_player_relation: { contested: true }
    mpr.reload

    assert_redirected_to tournament_path(t)
    assert !old_contested
    assert mpr.contested
  end
end
