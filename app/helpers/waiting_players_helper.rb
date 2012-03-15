module WaitingPlayersHelper
  def current_user_player
    user_id = current_user.nil? ? nil : current_user.id
    tournament_id = @tournament.nil? ? nil : @tournament.id
    WaitingPlayer.where(user_id: user_id, tournament_id: tournament_id).first
  end
end
