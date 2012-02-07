class MatchPlayerRelation < ActiveRecord::Base
  # Associations
  belongs_to :waiting_player
  belongs_to :match

  has_one :tournament, through: :waiting_player

  # Validations
  validates :waiting_player_id, presence: true
  validates :match_id, presence: true
  validates_associated :match

  # Attribute Whitelists
  attr_accessible :accepted, :contested, as: :member
  attr_accessible :waiting_player_id, :accepted, :contested, as: :moderator
  attr_accessible :waiting_player_id, :accepted, :contested, as: :admin
end
