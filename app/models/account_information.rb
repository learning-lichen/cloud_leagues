class AccountInformation < ActiveRecord::Base
  # Moderation Roles
  ADMIN = 2
  MODERATOR = 1
  MEMBER = 0

  ROLES = {
    ADMIN => :admin,
    MODERATOR => :moderator,
    MEMBER => :member
  }
  
  # Associations
  belongs_to :user

  # Validations
  validates :user_id, presence: true, uniqueness: true
  validates :reddit_name, presence: true, uniqueness: {
    message: 'has already been registered by another user'}
  validates :character_name, presence: true, uniqueness: {
    scope: :character_code, message: 'has already been registered'}
  validates :character_code, {presence: true, numericality: true, 
    length: {is: 3}}
  validates :role, presence: true, inclusion: {in: ROLES.keys}

  # Callbacks
  before_validation :strip_inputs

  # Attribute Whitelists
  attr_accessible :reddit_name, :character_name, :character_code, as: :member
  attr_accessible :reddit_name, :character_name, :character_code, as: :moderator
  attr_accessible :user_id, :reddit_name, :character_name, :character_code, :role, as: :admin

  protected
  def strip_inputs
    reddit_name.strip! if reddit_name
    character_name.strip! if character_name
    character_code.strip! if character_code
  end
end
