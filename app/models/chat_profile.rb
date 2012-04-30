class ChatProfile < ActiveRecord::Base
  # Associations
  belongs_to :user

  # Validations
  validates :user_id, :presence => true, :uniqueness => true
  validates :chat_id, :presence => true, :uniqueness => true
end
