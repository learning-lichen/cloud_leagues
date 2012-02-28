require 'test_helper'

class TournamentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index

    assert_response :success
  end

  test "should get new" do
    login :admin_user
    get :new

    assert_response :success
  end

  test "should not get new" do
    login :moderator_user
    get :new
    
    assert_redirected_to root_path
  end

  test "should create tournament" do
    login :admin_user
    start_time = 100.hours.from_now
    registration_time = 99.hours.from_now
    
    assert_difference 'Tournament.count' do
      post :create, tournament: { league: 0, 
        type: 'SingleEliminationTournament', 
        start_time: start_time, 
        registration_time: registration_time,
        name: 'New Tournament' }
    end
    assert_not_nil tournament = Tournament.find_by_start_time(start_time)
    assert_redirected_to tournament_path(tournament)
  end

  test "should not create tournament" do
    login :moderator_user
    start_time = 100.hours.from_now
    
    assert_difference 'Tournament.count', 0 do
      post :create, tournament: { league: 0, format: 0, start_time: start_time }
    end
    assert_nil Tournament.find_by_start_time(start_time)
    assert_redirected_to root_path
  end

  test "should show tournament" do
    get :show, id: tournaments(:all_tournament)

    assert_response :success
  end

  test "should get edit" do
    login :moderator_user
    get :edit, id: tournaments(:all_tournament).id

    assert_response :success
  end

  test "should update tournament" do
    login :moderator_user
    gm_tournament = tournaments(:grand_master_tournament)
    start_time = 100.hours.from_now
    old_time = gm_tournament.start_time
    put :update, id: gm_tournament.id, tournament: { start_time: start_time }
    gm_tournament.reload

    assert_redirected_to tournament_path(gm_tournament)
    assert_not_equal old_time, gm_tournament.start_time
  end

  test "should not update tournament" do
    login :default_user
    all_tournament = tournaments(:all_tournament)
    start_time = 100.hours.from_now
    old_time = all_tournament.start_time
    put :update, id: all_tournament.id, tournament: { start_time: start_time }
    all_tournament.reload

    assert_redirected_to root_path
    assert_equal old_time, all_tournament.start_time
  end

  test "should delete tournament" do
    login :admin_user
    all_tournament = tournaments(:all_tournament)
    delete :destroy, id: all_tournament.id

    assert_nil Tournament.find_by_id(all_tournament.id)
    assert_redirected_to tournaments_path
  end

  test "should not delete tournament" do
    login :moderator_user
    all_tournament = tournaments(:all_tournament)
    delete :destroy, id: all_tournament.id

    assert_not_nil Tournament.find_by_id(all_tournament.id)
    assert_redirected_to root_path
  end
end
