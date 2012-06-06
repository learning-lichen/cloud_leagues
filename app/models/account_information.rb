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

  # Races
  RANDOM = 0
  TERRAN = 1
  PROTOSS = 2
  ZERG = 3
  
  RACES = {
    RANDOM => I18n.t('races.random'),
    TERRAN => I18n.t('races.terran'),
    PROTOSS => I18n.t('races.protoss'),
    ZERG => I18n.t('races.zerg')
  }
  
  # Associations
  belongs_to :user
  has_attached_file :avatar, styles: { thumb: ["35x35#", :png] }, default_url: '/assets/missing_avatar.png'

  # Validations
  validates :user_id, presence: true, uniqueness: true
  validates :reddit_name, allow_nil: true, allow_blank: true, uniqueness: true
  validates :character_name, presence: true, uniqueness: { scope: :character_code }
  validates :character_code, presence: true, numericality: true, length: {is: 3}
  validates :role, presence: true, inclusion: { in: ROLES.keys }
  validates :race, presence: true, inclusion: { in: RACES.keys }
  validates :league, presence: true, inclusion: { in: Tournament::LEAGUES.keys }, exclusion: { in: [Tournament::ALL] }
  validates :time_zone, presence: true, inclusion: { in: ActiveSupport::TimeZone.us_zones.map { |z| z.name } }
  validates_attachment :avatar, content_type: { content_type: ['image/jpeg', 'image/pjpeg', 'image/png'], message: I18n.t('activerecord.errors.models.account_information.attributes.avatar.content_type') }, size: { in: 0..50.kilobytes, message: I18n.t('activerecord.errors.models.account_information.attributes.avatar.size') }

  # Callbacks
  before_validation :strip_inputs
  after_create :create_chat_profile

  # Attribute Whitelists
  attr_accessible :reddit_name, :character_name, :character_code, :race, :league, :time_zone, :avatar, as: :new_member
  attr_accessible :reddit_name, :race, :time_zone, :avatar, as: :member
  attr_accessible :reddit_name, :character_name, :character_code, :race, :league, :time_zone, :avatar, as: :moderator
  attr_accessible :user_id, :reddit_name, :character_name, :character_code, :role, :race, :league, :time_zone, :avatar, as: :admin

  protected
  def strip_inputs
    reddit_name.strip! if reddit_name
    character_name.strip! if character_name
    character_code.strip! if character_code
  end

  def create_chat_profile
    new_chat_profile = ChatProfile.new
    new_chat_profile.user_id = user.id
    new_chat_profile.chat_id = Authlogic::Random.hex_token[0..19]
    num_tried = 0

    while (!new_chat_profile.valid? && num_tried < 1000)      
      new_chat_profile.chat_id = Authlogic::Random.hex_token[0..19]
      num_tried += 1
    end

    new_chat_profile.save
  end
end
