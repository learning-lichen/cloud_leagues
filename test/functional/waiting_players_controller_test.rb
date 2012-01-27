require 'test_helper'

class WaitingPlayersControllerTest < ActionController::TestCase
  test "guest should be redirected" do
    all_tournament = tournaments(:all_tournament)
    default_waiting_all = waiting_players(:default_waiting_all)
    
    post :create, tournament_id: all_tournament.id
    assert_redirected_to login_path

    put :update, tournament_id: all_tournament.id, id: default_waiting_all.id
    assert_redirected_to login_path

    delete :destroy, tournament_id: all_tournament.id, id: default_waiting_all.id
    assert_redirected_to login_path
  end
  
  test "member should create waiting player" do
    login :default_user
    master_tournament = tournaments(:master_tournament)
    
    assert_difference 'WaitingPlayer.count' do
      post :create, tournament_id: master_tournament.id
    end
    assert_redirected_to tournament_path(master_tournament)
  end

  test "member should not update waiting player" do
    login :default_user
    all_tournament = tournaments(:all_tournament)
    default_waiting_all = waiting_players(:default_waiting_all)
    put :update, tournament_id: all_tournament.id, id: default_waiting_all.id, waiting_player: { player_accepted: true }
    default_waiting_all.reload

    assert_redirected_to root_path
    assert !default_waiting_all.player_accepted
  end

  test "should destroy waiting player" do
    login :default_user
    all_tournament = tournaments(:all_tournament)
    default_waiting_all = waiting_players(:default_waiting_all)
    
    assert_difference 'WaitingPlayer.count', -1 do
      delete :destroy, tournament_id: all_tournament.id, id: default_waiting_all.id
    end
    assert_redirected_to tournament_path(all_tournament)
  end
end
