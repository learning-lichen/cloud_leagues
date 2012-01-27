module TournamentsHelper
  def new_player(tournament, user)
    new_player = tournament.waiting_players.build
    new_player.user_id = user.id if user
    tournament.waiting_players.delete new_player
    new_player
  end
end
