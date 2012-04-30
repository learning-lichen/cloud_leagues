class SingleEliminationTournament < Tournament
  # The philosophy for creating a single elimination tournament is fairly simple. Due to
  # the format, there will always be byes if the number of players != 2^k for some k.
  # Therefore, the structure of this format is created as if there is 2^k players, where
  # 2^k is the next highest power of 2 greater than the set maximum number of players.
  # The matches are then split into levels, with each level having the previous number
  # divided by 2 matches. The levels are then linked together.
  def create_structure
    closest_power = Math.log2(max_players).ceil
    true_max_players = 2 ** closest_power
    
    match_list = []
    for match_level in 0..(closest_power - 1)
      match_list[match_level] = Array.new(true_max_players / (2 ** (match_level + 1)))
      
      for i in 0..(match_list[match_level].length - 1)
        new_match = self.matches.build
        new_match.best_of = default_best_of
        
        if new_match.save
          new_game = new_match.games.build

          if new_game.save
            match_list[match_level][i] = new_match
          else
            logger.warn 'Error creating tournament structure.'
            errors.add :type, 'could not be created at this time. Please try again later'
            destroy_structure
            return false
          end
        else
          logger.warn 'Error creating tournament structure.'
          errors.add :type, 'could not be created at this time. Please try again later'
          destroy_structure
          return false
        end
        
        if match_level != 0
          first_link = match_list[match_level - 1][2 * i].winner_match_links.build
          first_link.next_match_id = match_list[match_level][i].id
          
          second_link = match_list[match_level - 1][2 * i + 1].winner_match_links.build
          second_link.next_match_id = match_list[match_level][i].id
          
          unless first_link.save && second_link.save
            logger.warn 'Error creating tournament structure.'
            errors.add :type, 'could not be created at this time. Please try again later'
            destroy_structure
            return false
          end
        end
      end
    end

    true
  end

  # The strategy for adding players to this tournament is as follows:
  # If there is an empty match, add the new players to that. If no empty match is found, 
  # then add a player to a random open match. This should randomly distribute the byes.
  def add_player(waiting_player)
    waiting_player.player_accepted = true
      
    if waiting_player.valid?
      waiting_player.update_column :player_accepted, true

      match = find_match_for_new_player
      new_players_relation = find_match_for_new_player.match_player_relations.build
      new_players_relation.waiting_player_id = waiting_player.id
      
      waiting_player.update_column(player_accepted, false) unless new_players_relation.save
    end

    true
  end

  def can_delete_player?(waiting_player)
    can_delete = false

    if waiting_player.matches.length == 1
      can_delete = true if waiting_player.matches.first.winner_id.nil?
    end

    can_delete
  end

  def to_partial_path
    "tournaments/tournament"
  end

  protected
  def find_match_for_new_player
    available_matches = starting_matches
    empty_matches = []
    one_player_matches = []
    
    available_matches.each do |match|
      match_valid = true
      match.match_links.each do |link|
        match_to_check = Match.find_by_id link.next_match_id
        match_valid = false if match_to_check && !match_to_check.winner_id.nil?
      end
      
      if match.match_player_relations.empty? && match_valid
        empty_matches.push match
      elsif match.match_player_relations.length == 1 && match_valid
        one_player_matches.push match
      end
    end

    new_players_match = one_player_matches[Random.rand(one_player_matches.length)] unless one_player_matches.empty?
    new_players_match ||= empty_matches.first
    new_players_match
  end
end
