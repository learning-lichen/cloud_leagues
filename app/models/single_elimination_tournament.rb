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
        
        if new_match.save 
          match_list[match_level][i] = new_match 
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

  # Updating tournaments is a fairly complicated process because of the implications 
  # involved in updating some of the attributes. I have decided to take a fairly strict
  # approach to updating tournaments for the following reasons:
  # 1) The most important aspect of any website is the user experience. I do not want to
  #    have any unexpected behavior (e.g. randomly dropping players from tournaments).
  # 2) Tournament admins should be responsible. They shouldn't have to update something
  #    like start time after the tournament has already started.
  def update_structure
    if started?
      error_end = 'once tournament has started'
      errors.add :league, 'cannot be changed' + error_end if league_changed?
      errors.add :start_time, 'cannot be changed' + error_end if start_time_changed?
      errors.add :max_players, 'cannot be changed' + error_end if max_players_changed?
      errors.add :type, 'cannot be changed' + error_end if type_changed?
      errors.add :locked, 'cannot be changed' + error_end if locked_changed?
      errors.add :registration_time, 'cannot be changed' + error_end if registration_time_changed?
      raise ActiveRecord::Rollback
    end
  end

  def destroy_structure
    matches.each { |match| match.destroy }
  end

  protected
  def starting_matches
    match_list = matches
    starting_matches = matches

    match_list.each do |match|
      match.match_links.each do |match_link|
        start_matches.delete_if { |x| x.id == match_link.next_match_id }
      end
    end

    starting_matches
  end
end
