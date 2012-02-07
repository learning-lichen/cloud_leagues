class Match < ActiveRecord::Base
  # Associations
  belongs_to :tournament
  
  has_many :match_player_relations, dependent: :destroy
  has_many :waiting_players, through: :match_player_relations
  has_many :replays, dependent: :destroy
  has_many :match_links, dependent: :destroy
  has_many :winner_match_links, dependent: :destroy

  # Validations
  validates :tournament_id, presence: true
  validates :match_player_relations, length: { maximum: 2 }
  validates :winner_id, inclusion: { 
    in: lambda { |match| match.waiting_players.map { |player| player.id } }
  }, if: :winner_id
  
  # Attribute Whitelists
  attr_accessible :winner_id, as: :moderator
  attr_accessible :winner_id, as: :admin
end

