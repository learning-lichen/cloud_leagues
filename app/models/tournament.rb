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
  validate :validate_waiting_players

  # Attribute Whitelists
  attr_accessible :league, :type, :start_time, :max_players, as: :moderator
  attr_accessible :league, :type, :start_time, :max_players, as: :admin

  def started?
    Time.now >= start_time
  end

  def initialize_tournament
    raise NotImplementedError.new('Not implemented in the super class.')
  end

  protected
  def validate_waiting_players
    accepted_count = 0
    waiting_players.each { |player| accepted_count += 1 if player.player_accepted }
    errors.add(:waiting_players, "too many accepted") if accepted_count > (max_players || 0)
  end
end
