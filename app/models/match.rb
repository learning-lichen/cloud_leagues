class Match < ActiveRecord::Base
  # Associations
  belongs_to :tournament
  
  has_many :match_player_relations
  has_many :waiting_players, through: :match_player_relations
  has_many :replays
  has_many :match_links
  has_many :winner_match_links

  # Validations
  validates :tournament_id, presence: true
  validates :winner_id, inclusion: { 
    in: lambda { |match| match.waiting_players.map { |player| player.id } }
  }, if: :winner_id
  
  # Attribute Whitelists
  attr_accessible :tournament_id, :winner_id, as: :moderator
  attr_accessible :tournament_id, :winner_id, as: :admin
end

