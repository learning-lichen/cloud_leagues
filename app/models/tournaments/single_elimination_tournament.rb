class SingleEliminationTournament < Tournament
  def create_structure
    closest_power = Math.log2(max_players).ceil
    true_max_players = 2 ** closest_power
    
    match_list = []
    for match_level in 0..(closest_power - 1)
      match_list[match_level] = Array.new(true_max_players / (2 ** (match_level + 1)))
      
      for i in 0..(match_list[match_level].length - 1)
        new_match = self.matches.build
        new_match.save ? match_list[match_level][i] = new_match : self.destroy
        
        if match_level != 0
          first_link = match_list[match_level - 1][2 * i].winner_match_links.build
          first_link.next_match_id = match_list[match_level][i].id
          
          second_link = match_list[match_level - 1][2 * i + 1].winner_match_links.build
          second_link.next_match_id = match_list[match_level][i].id
          
          self.destroy unless first_link.save && second_link.save
        end
      end
    end
  end

  def destroy_structure
    matches.each { |match| match.destroy }
  end
end
