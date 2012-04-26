class Game < ActiveRecord::Base
  # Associations
  belongs_to :match

  has_many :replays, dependent: :destroy

  # Validations
  validates :match_id, presence: true
  validates :winner_id, inclusion: {
    in: lambda { |game| game.match.waiting_players.map { |wp| wp.id } }
  }, if: :winner_id

  # Callbacks
  after_update :check_for_match_winner

  # Attribute Whitelists
  attr_accessible :winner_id, as: :member
  attr_accessible :winner_id, as: :moderator
  attr_accessible :winner_id, as: :admin

  protected
  def check_for_match_winner
    if winner_id_changed? && !winner_id.blank? && (match.games.where(winner_id: winner_id).count * 2 > match.best_of || match.bye?)
      match.winner_id = winner_id
      match.save
    elsif winner_id_changed? && !winner_id.blank? && match.games.where(winner_id: nil).count == 0
      match.games.build.save
    end
  end
end
