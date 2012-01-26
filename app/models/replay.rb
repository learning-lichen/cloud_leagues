class Replay < ActiveRecord::Base
  # Associations
  belongs_to :match
  
  # Validations
  validates :match_id, :presence => true
  validates :replay_url, :presence => true
  validates :uploader_id, :presence => true

  protected
  def authorize
    current_user = UserSession.find.user
    
    if current_user.role == AccountInformation::ADMIN
      # Admins can do anything.
      return true
      
    elsif current_user.role == AccountInformation::MODERATOR
      # Moderators can manage replays.
      return true

    else
      # Members can only add replays to their games. 
      return false unless new_record? && [match.player_one_id, match.player_two_id].include?(current_user.id)
      return false if uploader_id != current_user.id
      return false if match.replays.size > 2
    end
  end
end
