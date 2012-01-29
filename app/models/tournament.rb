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
    ALL => 'All',
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
  validates :league, presence: true, inclusion: {in: LEAGUES.keys}
  validates :format, presence: true, inclusion: {in: FORMATS.keys}
  validates :start_time, presence: true
  validates :max_players, presence: true

  # Attribute Whitelists
  attr_accessible :league, :format, :start_time, :max_players, as: :moderator
  attr_accessible :league, :format, :start_time, :max_players, as: :admin
end
