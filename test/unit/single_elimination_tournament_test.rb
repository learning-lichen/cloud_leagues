require 'test_helper'

class SingleEliminationTournamentTest < ActiveSupport::TestCase
  test "create structure" do
    empty_tournament = Tournament.new
    empty_tournament.start_time = Time.now
    empty_tournament.type = 'SingleEliminationTournament'
    closest_power = Math.log2(empty_tournament.max_players).ceil

    empty_tournament.save
    matches = empty_tournament.matches
    empty_link_matches = 0
    
    assert_equal (2 ** closest_power) - 1, matches.length
    matches.each do |match| 
      current_match_link = match.match_links
      next_match_links = MatchLink.find_all_by_next_match_id(match.id)
      empty_link_matches += 1 if current_match_link.empty?
      
      assert_equal 1, current_match_link.length unless current_match_link.empty?
      assert_equal 2, next_match_links.length unless next_match_links.empty?
    end
    assert_equal 1, empty_link_matches
  end
end
