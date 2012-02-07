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
  has_many :waiting_players, dependent: :destroy
  has_many :matches, dependent: :destroy
  
  # Validations
  validates :league, presence: true, inclusion: {in: LEAGUES.keys}
  validates :format, presence: true, inclusion: {in: FORMATS.keys}
  validates :start_time, presence: true
  validates :max_players, presence: true

  # Callbacks
  after_initialize :include_format
  after_create :initialize_tournament

  # Attribute Whitelists
  attr_accessible :league, :format, :start_time, :max_players, as: :moderator
  attr_accessible :league, :format, :start_time, :max_players, as: :admin

  def started?
    Time.now >= start_time
  end

  protected
  def include_format
    module_to_extend = FORMATS[self.format]
    extend module_to_extend.gsub(/ /, '').constantize if module_to_extend
  end
end
