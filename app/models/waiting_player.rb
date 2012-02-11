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

  # Attribute Whitelists
  attr_accessible :player_accepted, as: :moderator
  attr_accessible :player_accepted, as: :admin

  protected
  def validate_users_league
    return if tournament.nil?

    errors.add :user, 'must have account information' and return if user.account_information.nil?
    
    user_league = user.account_information.league
    errors.add :user, 'must be in the tournaments league' unless tournament.league == Tournament::ALL or user_league == tournament.league
  end
end
