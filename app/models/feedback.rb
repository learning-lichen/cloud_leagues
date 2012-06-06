class Feedback < ActiveRecord::Base
  # Categories
  FEATURE_REQUEST = 0
  BUG_REPORT = 1
  COMMENT = 2
  OTHER = 3

  CATEGORIES = {
    FEATURE_REQUEST => I18n.t('feedback.categories.feature_request'),
    BUG_REPORT => I18n.t('feedback.categories.bug_report'),
    COMMENT => I18n.t('feedback.categories.comment'),
    OTHER => I18n.t('feedback.categories.other')
  }

  # Associations
  belongs_to :user

  # Validations
  validates :message, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES.keys }

  # Attribute Whitelists
  attr_accessible :message, :category, as: :guest
  attr_accessible :user_id, :message, :category, as: :member
  attr_accessible :user_id, :message, :category, as: :moderator
  attr_accessible :user_id, :message, :category, as: :admin
end
