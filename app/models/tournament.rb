class Tournament < ActiveRecord::Base
  # Leagues
  ALL = 0b1111111
  GRAND_MASTER = 0b1000000
  MASTER = 0b0100000
  DIAMOND = 0b0010000
  PLATINUM = 0b0001000
  GOLD = 0b0000100
  SILVER = 0b0000010
  BRONZE = 0b0000001

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
  has_many :map_lists, order: 'map_order ASC', dependent: :destroy
  has_many :maps, through: :map_lists
  
  # Validations
  validates :league, presence: true, inclusion: { in: 1..127, message: 'is not valid' }
  validates :max_players, presence: true, inclusion: { in: 1..64 }
  validates :name, presence: true, uniqueness: true, length: { within: 5..25 }
  validates :prize, presence: true, inclusion: { in: 0..4999, message: 'must be within $0 and $4,999' }
  validates :default_best_of, presence: true, inclusion: { in: [1, 3, 5, 7, 9, 11] }
  validate :validate_waiting_players
  validate :validate_type
  validate :validate_times
  validate :validate_map_list

  # Callbacks
  before_validation :strip_inputs
  after_create :create_structure
  after_update :update_structure

  # Attribute Whitelists
  attr_accessible :league, :type, :start_time, :registration_time, :max_players, :name, :map_lists_attributes, :default_best_of, as: :moderator
  attr_accessible :league, :type, :start_time, :registration_time, :max_players, :name, :prize, :map_lists_attributes, :default_best_of, as: :admin

  # Nested Attributes
  accepts_nested_attributes_for :map_lists, allow_destroy: true, reject_if: lambda { |a| a[:map_id].blank? }

  def started?
    Time.now >= start_time
  end

  def open_spots
    [0, max_players - waiting_players.where(player_accepted: true).count].max
  end

  def starting_matches
    match_list = matches
    start_matches = matches
    
    match_list.each do |match|
      match.match_links.each do |match_link|
        start_matches = start_matches.where("id != ?", match_link.next_match_id)
      end
    end
    
    start_matches
  end

  protected
  def strip_inputs
    name.strip! if name
  end

  def create_structure
    raise ActiveRecord::Rollback unless self.becomes(type.constantize).create_structure
  end

  # Updating tournaments is a fairly complicated process because of the implications 
  # involved in updating some of the attributes. I have decided to take a fairly strict
  # approach to updating tournaments for the following reasons:
  # 1) The most important aspect of any website is the user experience. I do not want to
  #    have any unexpected behavior (e.g. randomly dropping players from tournaments).
  # 2) Tournament admins should be responsible. They shouldn't have to update something
  #    like start time after the tournament has already started.
  # 3) Allowing tournament modification after a tournament has started leads to an
  #    extremely large number of edge cases. It doesn't make sense to try and handle
  #    these all.
  def update_structure
    # Check for errors.
    errors.add :type, 'cannot be changed' if type_changed?
    errors.add :start_time, 'cannot be changed once started' if start_time_changed? and start_time_was <= Time.now
    
    if started?
      error_end = 'once tournament has started'
      errors.add :league, 'cannot be changed' + error_end if league_changed?
      errors.add :start_time, 'cannot be changed' + error_end if start_time_changed?
      errors.add :max_players, 'cannot be changed' + error_end if max_players_changed?
      errors.add :registration_time, 'cannot be changed' + error_end if registration_time_changed?
    end

    if locked?
      error_end = 'if tournament is locked'
      errors.add :league, 'cannot be changed' + error_end if league_changed?
      errors.add :start_time, 'cannot be changed' + error_end if start_time_changed?
      errors.add :max_players, 'cannot be changed' + error_end if max_players_changed?
      errors.add :registration_time, 'cannot be changed' + error_end if registration_time_changed?
    end

    raise ActiveRecord::Rollback unless errors.empty?
    
    if max_players_changed?
      destroy_structure
      reload
      create_structure
      waiting_players.where(player_accepted: true).each { |player| add_player(player) }
    end
  end

  def destroy_structure
    matches.each { |match| match.destroy }
  end

  def validate_waiting_players
    return if league.nil?
    accepted_count = 0
    all_players_belong = true

    waiting_players.each do |player| 
      accepted_count += 1 if player.player_accepted
      all_players_belong = false if ((player.user.account_information.league & league) == 0)
    end
    
    errors.add(:waiting_players, 'too many accepted') if accepted_count > (max_players || 0)
    errors.add(:waiting_players, 'do not belong to this tournaments league') unless all_players_belong
  end

  def validate_type
    errors.add(:type, 'must be present') and return if type.nil?
    errors.add(:type, 'cannot be changed') if !new_record? and type_changed?
    tournament_file_names = Dir.glob('app/models/*_tournament.rb').map do |file_name|
      File.basename file_name, '.rb'
    end

    class_names = tournament_file_names.map do |file_name|
      file_name.split('_').map { |w| w.capitalize }.join
    end

    errors.add(:type, 'is not a valid tournament type') unless class_names.include?(type)
  end
  
  def validate_times
    errors.add(:start_time, 'must be present') and return if start_time.nil?
    errors.add(:start_time, 'must be in the future') and return if new_record? and start_time <= Time.now
    errors.add(:registration_time, 'must be present') and return if registration_time.nil?
    errors.add(:registration_time, 'must be before start time') and return if registration_time >= start_time
  end

  def validate_map_list
    errors.add :map_lists, 'must have a map with order 1' if map_lists.select { |ml| ml.map_order == 1 }.empty?
  end
end
