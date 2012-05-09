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
  attr_accessible :login, :email, :password, :password_confirmation, as: :guest
  attr_accessible :email, :password, :password_confirmation, as: :member
  attr_accessible :email, :password, :password_confirmation, as: :moderator
  attr_accessible :login, :email, :password, :password_confirmation, as: :admin

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

  # Returns an array in the form of [wins, losses]
  def win_loss_array
    win_count = 0
    loss_count = 0

    waiting_players.each do |player|
      player.matches.each do |match| 
        if match.winner_id == player.id
          win_count += 1
        elsif !match.winner_id.nil?
          loss_count += 1
        end
      end
    end
    
    [win_count, loss_count]
  end

  def time_zone
    account_information.nil? ? nil : account_information.time_zone
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  def avatar_url
    avatar = nil
    if account_information.nil?
      avatar = AccountInformation.new.avatar.url(:thumb)
    else
      avatar = account_information.avatar.url(:thumb)
    end
    avatar
  end

  protected
  def strip_inputs
    login.strip! if login
    email.strip! if email
  end
end
