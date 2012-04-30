class WinnerMatchLink < MatchLink
  def match_won(new_winner, old_winner)
    if (old_winner != new_winner)
      next_match = Match.find next_match_id
      next_match.match_player_relations.where(waiting_player_id: old_winner).destroy_all
      
      new_winner_relation = next_match.match_player_relations.build 
      new_winner_relation.waiting_player_id = new_winner
      new_winner_relation.save
    end
  end
end
