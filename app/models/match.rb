class Match < ActiveRecord::Base
  # Associations
  belongs_to :tournament
  
  has_many :match_player_relations, dependent: :destroy
  has_many :waiting_players, through: :match_player_relations
  has_many :games, order: 'id ASC', dependent: :destroy
  has_many :replays, through: :games
  has_many :match_links, dependent: :destroy
  has_many :winner_match_links, dependent: :destroy

  # Validations
  validates :tournament_id, presence: true
  validates :best_of, presence: true, inclusion: { in: [1, 3, 5, 7, 9, 11] }
  validates :match_player_relations, length: { maximum: 2 }
  validates :winner_id, inclusion: { 
    in: lambda { |match| match.waiting_players.map { |player| player.id } }
  }, if: :winner_id

  # Callbacks
  after_update :update_match_links
       
  # Attribute Whitelists
  attr_accessible :games_attributes, as: :member
  attr_accessible :winner_id, :games_attributes, as: :moderator
  attr_accessible :winner_id, :games_attributes, as: :admin

  # Nested Attributes
  accepts_nested_attributes_for :games, allow_destroy: false, reject_if: lambda { |a| a[:id].blank? }

  # Delegations
  delegate :empty?, to: :match_player_relations

  def next_matches
    match_links.map do |ml|
      Match.find ml.next_match_id
    end
  end

  def previous_matches
    immediately_before = MatchLink.where(next_match_id: id).map { |ml| ml.match }
    other_previous = immediately_before.map { |m| m.previous_matches }

    other_previous.reduce(immediately_before) { |all_previous, m| all_previous.push m }.flatten
  end

  def contested?
    prev_match_contested = false
    previous_matches.each do |m|
      prev_match_contested = true if m.contested?
    end

    !match_player_relations.where(contested: true).empty? || prev_match_contested
  end

  def bye?
    is_bye = true
    is_bye = false unless match_player_relations.count == 1
    
    previous_matches.each do |match|
      is_bye = false unless match.resolved?
    end

    is_bye
  end

  def resolved?
    previous_resolved = previous_matches.reduce(true) do |resolved, match|
      resolved = resolved && match.resolved?
    end

    (!winner_id.nil? || empty?) && previous_resolved
  end

  protected
  def update_match_links
    if winner_id_changed? && !winner_id.blank?
      match_links.each { |ml| ml.match_won(winner_id, winner_id_was) }
    end
  end
end

