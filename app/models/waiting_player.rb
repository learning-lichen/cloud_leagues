class WaitingPlayer < ActiveRecord::Base
  # Associations
  belongs_to :tournament
  belongs_to :user
  
  has_many :match_player_relations, dependent: :destroy
  has_many :matches, through: :match_player_relations

  # Validations
  validates :tournament_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :tournament_id }

  # Attribute Whitelists
  attr_accessible :player_accepted, as: :moderator
  attr_accessible :tournament_id, :user_id, :player_accepted, as: :admin
end
