class ChatProfile < ActiveRecord::Base
  # Associations
  belongs_to :user

  # Validations
  validates :user_id, :presence => true, :uniqueness => true
  validates :chat_id, :presence => true, :uniqueness => true

  # Callbacks
  before_save :authorize

  protected
  def authroize
    # There should be no external modification, so always return true.
    return true
  end
end
