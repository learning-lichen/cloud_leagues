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

  # Associations
  has_many :waiting_players, dependent: :destroy
  has_many :matches, dependent: :destroy
  
  # Validations
  validates :league, presence: true, inclusion: {in: LEAGUES.keys}
  validates :type, presence: true
  validates :start_time, presence: true
  validates :max_players, presence: true

  # Attribute Whitelists
  attr_accessible :league, :type, :start_time, :max_players, as: :moderator
  attr_accessible :league, :type, :start_time, :max_players, as: :admin

  def started?
    Time.now >= start_time
  end
end
