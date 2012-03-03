module TournamentsHelper
  def new_player(tournament, user)
    new_player = tournament.waiting_players.build
    new_player.user_id = user.id if user
    tournament.waiting_players.delete new_player
    new_player
  end

  def to_time_remaining(tournament_start_time)
    secs_remaining = (tournament_start_time - Time.now).to_i
    neg_flag = secs_remaining < 0 ? '-' : ''
    secs_remaining = secs_remaining.abs

    mins_remaining = secs_remaining / 60
    hours_remaining = mins_remaining / 60
    days_remaining = hours_remaining / 24

    if days_remaining > 0 
      "#{neg_flag}#{days_remaining}d, #{hours_remaining % 24}h"
    elsif hours_remaining > 0
      "#{neg_flag}#{hours_remaining}h, #{mins_remaining % 60}m"
    elsif mins_remaining > 0
      "#{neg_flag}#{mins_remaining}m, #{secs_remaining % 60}s"
    else secs_remaining >= 0
      "#{neg_flag}#{secs_remaining}s"
    end
  end

  def image_for_league(league_id)
    "#{Tournament::LEAGUES[league_id].gsub(/ /, '_').underscore}.png"
  end
end
