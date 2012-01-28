require 'test_helper'

class MatchesControllerTest < ActionController::TestCase
  test "should show match" do
    get :show, id: matches(:all_match_one).id
    
    assert_response :success
  end

  test "should get new" do
    login :moderator_user
    get :new

    assert_response :success
  end

  test "should redirect new for members" do
    login :default_user
    get :new
    
    assert_redirected_to root_path
  end

  test "should create match" do
    login :admin_user
    all_tournament = tournaments(:all_tournament)
    player_one = users(:default_user)
    player_two = users(:admin_user)

    assert_difference 'Match.count' do
      post :create, match: { tournament_id: all_tournament.id,
        player_one_id: player_one.id, player_two_id: player_two.id }
    end
  end
end
