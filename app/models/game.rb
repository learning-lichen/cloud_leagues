class Game < ActiveRecord::Base
  # Associations
  belongs_to :match

  has_many :replays

  # Validations
  validates :match_id, presence: true
  validates :winner_id, inclusion: {
    in: lambda { |game| game.match.waiting_players.map { |wp| wp.user.id } }
  }, if: :winner_id

  # Attribute Whitelists
  attr_accessible :winner_id, as: :member
  attr_accessible :winner_id, as: :moderator
  attr_accessible :winner_id, as: :admin
end
