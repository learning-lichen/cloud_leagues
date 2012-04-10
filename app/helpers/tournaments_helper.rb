module TournamentsHelper
  def new_player(tournament, user)
    new_player = tournament.waiting_players.build
    new_player.user_id = user.id if user
    tournament.waiting_players.delete new_player
    new_player
  end

  def to_time_remaining(tournament_start_time)
    secs_remaining = (tournament_start_time - Time.now).to_i
    neg_flag = secs_remaining < 0 ? ' ago' : ''
    secs_remaining = secs_remaining.abs

    mins_remaining = secs_remaining / 60
    hours_remaining = mins_remaining / 60
    days_remaining = hours_remaining / 24

    if days_remaining > 0 
      "#{days_remaining}d#{neg_flag}"
    elsif hours_remaining > 0
      "#{neg_flag}#{hours_remaining}h#{neg_flag}"
    elsif mins_remaining > 0
      "#{neg_flag}#{mins_remaining}m#{neg_flag}"
    else secs_remaining >= 0
      "< 1m#{neg_flag}"
    end
  end

  def image_for_league(league_id)
    "#{Tournament::LEAGUES[league_id].gsub(/ /, '_').underscore}.png"
  end

  def match_levels(tournament)
    num_levels = Math.log2(tournament.max_players).ceil
    levels = []
    
    levels.push tournament.starting_matches
    last_levels = levels[0]
    
    (num_levels - 1).times do 
      new_levels = last_levels.map do |match|
        match.match_links.map do |ml|
          Match.find ml.next_match_id
        end
      end

      new_levels.flatten!
      new_levels = new_levels | new_levels
      levels.push new_levels
      last_levels = new_levels
    end

    levels
  end

  def current_match(tournament, player)
    starting_match = (tournament.matches.joins(:match_player_relations).where('match_player_relations.waiting_player_id' => player.id) & tournament.starting_matches).first

    match = starting_match
    
    while match.winner_id && match.winner_id == player.id
      match = match.winner_match_links.first.match
    end

    match
  end
end
