require 'test_helper'

class SingleEliminationTournamentTest < ActiveSupport::TestCase
  test "create structure" do
    tournament_params = {
      start_time: 1.hours.from_now,
      registration_time: 2.hours.ago,
      type: 'SingleEliminationTournament',
      name: 'New Tournament',
      league: Tournament::ALL,
      default_best_of: 3,
      map_lists_attributes: [{ map_id: 1, map_order: 1 }]
    }

    empty_tournament = Tournament.create tournament_params, as: :admin
    closest_power = Math.log2(empty_tournament.max_players).ceil

    empty_tournament.save
    matches = empty_tournament.matches
    empty_link_matches = 0
    
    assert_equal (2 ** closest_power) - 1, matches.length
    assert_equal (2 ** closest_power) - 1, empty_tournament.games.length
    matches.each do |match| 
      current_match_link = match.match_links
      next_match_links = MatchLink.find_all_by_next_match_id(match.id)
      empty_link_matches += 1 if current_match_link.empty?
      
      assert_equal 1, current_match_link.length unless current_match_link.empty?
      assert_equal 2, next_match_links.length unless next_match_links.empty?
    end
    assert_equal 1, empty_link_matches
  end

  test "player added" do
    master_tournament = tournaments(:master_tournament)
    master_tournament.waiting_players.each { |wp| wp.destroy }
    master_tournament.max_players = 8
    master_tournament.save

    mod_user = users(:moderator_user)
    new_player = master_tournament.waiting_players.build
    new_player.user_id = mod_user.id
    new_player.save

    assert_equal 1, new_player.matches.length
  end

  test "can delete player" do
    all_tournament = tournaments(:all_tournament)
    default_waiting_all = waiting_players(:default_waiting_all)
    mod_waiting_all = waiting_players(:mod_waiting_all)
    other_mod_waiting_all = waiting_players(:other_mod_waiting_all)
    
    assert all_tournament.can_delete_player?(default_waiting_all)
    assert !all_tournament.can_delete_player?(mod_waiting_all)
    assert !all_tournament.can_delete_player?(other_mod_waiting_all)
  end
end
