module SharedHelper
  def top_players(limit = 5)
    players = Match.group(:winner_id).order('count_all DESC').limit(limit).count
    players.delete(nil)
    players
  end

  def large_prize_tournaments(league = Tournament::ALL, limit = 3)
    Tournament.where('registration_time < ? AND start_time > ? AND league & ? > 0', Time.now, Time.now, league).order('prize DESC').limit(limit)
  end
end
