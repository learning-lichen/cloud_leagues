class Feedback < ActiveRecord::Base
  # Categories
  FEATURE_REQUEST = 0
  BUG_REPORT = 1
  COMMENT = 2
  OTHER = 3

  CATEGORIES = {
    FEATURE_REQUEST => 'Feature Request',
    BUG_REPORT => 'Bug Report',
    COMMENT => 'Comment',
    OTHER => 'Other'
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
