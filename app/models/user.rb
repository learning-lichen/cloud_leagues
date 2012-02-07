class User < ActiveRecord::Base
  # Authlogic Configuration
  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::Sha512
  end

  # Associations
  has_one :account_information, dependent: :destroy
  has_one :chat_profile, dependent: :destroy
  has_many :waiting_players
  has_many :tournaments, through: :waiting_players
  has_many :matches, through: :waiting_players

  # Callbacks
  before_validation :strip_inputs

  # Attribute Whitelists
  attr_accessible :login, :email, :password, :password_confirmation, :as => :guest
  attr_accessible :email, :password, :password_confirmation, :as => :member
  attr_accessible :email, :password, :password_confirmation, :as => :moderator
  attr_accessible :login, :email, :password, :password_confirmation, :as => :admin

  def role
    if new_record?
      user_role = :guest
    elsif account_information
      user_role = AccountInformation::ROLES[account_information.role]
    else
      user_role = :member
    end
  end

  def role?(role)
    user_is_of_role = false
    
    if new_record?
      user_is_of_role = true if role == :guest
    elsif account_information
      user_role = account_information.role
      user_is_of_role = true if role == AccountInformation::ROLES[user_role]
    else
      user_is_of_role = true if role == :member
    end
    
    user_is_of_role
  end

  protected
  def strip_inputs
    login.strip! if login
    email.strip! if email
  end
end
