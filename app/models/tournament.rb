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
  validates :league, presence: true, inclusion: { in: LEAGUES.keys }
  validates :max_players, presence: true, inclusion: { in: 1..64 }
  validate :validate_waiting_players
  validate :validate_type
  validate :validate_times

  # Callbacks
  after_create :create_structure

  # Attribute Whitelists
  attr_accessible :league, :type, :start_time, :registration_time, :max_players, as: :moderator
  attr_accessible :league, :type, :start_time, :registration_time, :max_players, as: :admin

  def started?
    Time.now >= start_time
  end

  protected
  def create_structure
    raise ActiveRecord::Rollback unless self.becomes(type.constantize).create_structure
  end
  
  def destroy_structure
    raise ActiveRecord::Rollback unless self.becomes(type.constantize).destroy_structure
  end

  def validate_waiting_players
    accepted_count = 0
    waiting_players.each { |player| accepted_count += 1 if player.player_accepted }
    errors.add(:waiting_players, 'too many accepted') if accepted_count > (max_players || 0)
  end

  def validate_type
    errors.add(:type, 'must be present') and return if type.nil?
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
    errors.add(:start_time, 'must be in the future') and return if new_record? && start_time <= Time.now
    errors.add(:registration_time, 'must be present') and return if registration_time.nil?
    errors.add(:registration_time, 'must be before start time') and return if registration_time >= start_time
  end
end
