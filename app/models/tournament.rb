class Tournament < ActiveRecord::Base
  # Leagues
  ALL = 0
  GRAND_MASTER = 1
  MASTER = 2
  DIAMOND = 3
  PLATINUM = 4
  GOLD = 5
  SILVER = 6
  BRONZE = 7

  LEAGUES = {
    ALL => 'All Leagues',
    GRAND_MASTER => 'Grand Master',
    MASTER => 'Master',
    DIAMOND => 'Diamond',
    PLATINUM => 'Platinum',
    GOLD => 'Gold',
    SILVER => 'Silver',
    BRONZE => 'Bronze'
  }
  
  # Formats
  SINGLE_ELIMINATION = 0

  FORMATS = {
    SINGLE_ELIMINATION => 'Single Elimination'
  }

  # Associations
  has_many :waiting_players
  has_many :matches

  # Validations
  validates :league, :presence => true, :inclusion => {:in => LEAGUES.keys}
  validates :format, :presence => true, :inclusion => {:in => FORMATS.keys}
  validates :start_time, :presence => true

  protected
  def authorize
    current_user = UserSession.find.user

    if current_user.role == AccountInformation::ADMIN
      # Admins can do anything, place no restriction on them.
      return true
      
    elsif current_user.role == AccountInformation::MODERATOR
      # Mods can modify any tournament.
      return true
      
    else
      # Regular users cannot modify any tournament.
      return false
    end
  end
end
