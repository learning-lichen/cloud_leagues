class WaitingPlayer < ActiveRecord::Base
  # Associations
  belongs_to :tournament
  belongs_to :user
  
  has_many :match_player_relations, dependent: :destroy
  has_many :matches, through: :match_player_relations

  # Validations
  validates :tournament_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :tournament_id }
  validates_associated :tournament
  validate :validate_users_league
  validate :validate_player_acceptance

  # Callbacks
  after_create :notify_tournament_of_add

  # Attribute Whitelists
  attr_accessible :player_accepted, :user_id, as: :moderator
  attr_accessible :player_accepted, :user_id, as: :admin

  protected
  def validate_users_league
    return if tournament.nil?
    errors.add :user, 'must have account information' and return if user.account_information.nil?
    
    user_league = user.account_information.league
    errors.add :user, 'must be in the tournaments league' unless ((user_league & tournament.league) > 0)
  end

  def validate_player_acceptance    
    if (player_accepted_changed? && player_accepted) || (new_record? && player_accepted)
      errors.add :player_accepted, 'too many' if tournament.waiting_players.where(player_accepted: true).length >= tournament.max_players
    end
  end

  def notify_tournament_of_add
    tournament.add_player(self)
  end
end
