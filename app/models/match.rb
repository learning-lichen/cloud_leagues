class Match < ActiveRecord::Base
  # Associations
  belongs_to :tournament
  belongs_to :player_one, class_name: :User
  belongs_to :player_two, class_name: :User
  has_many :replays

  # Validations
  validates :tournament_id, :presence => true
  validates :player_one_id, :presence => true
  validates :player_two_id, :presence => true

  # Attribute Whitelists
  attr_accessible :tournament_id, :player_one_id, :player_two_id, :player_one_accepts, :player_two_accepts, :winner, :contested, as: :moderator
  attr_accessible :tournament_id, :player_one_id, :player_two_id, :player_one_accepts, :player_two_accepts, :winner, :contested, as: :admin
end

