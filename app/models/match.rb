class Match < ActiveRecord::Base
  # Associations
  belongs_to :tournament
  has_many :replays

  # Validations
  validates :tournament_id, :presence => true
  validates :player_one_id, :presence => true
  validates :player_two_id, :presence => true

  protected
  def authorize
    current_user = UserSession.find.user
    current_match = Match.find_by_id(id) || Match.new

    if current_user.role == AccountInformation::ADMIN
      # Admins can do anything.
      return true
      
    elsif current_user.role == AccountInformation::MODERATOR
      # Moderators can change matches.
      return true
      
    else
      # Members can accept, decide a winner, and contest a match they are in.
      return false unless [player_one_id, player_two_id].include? current_user.id
      return false if winner && (!player_one_accepted || !player_two_accepted)
      return false if current_match.contested && !contested
    end
  end
end
