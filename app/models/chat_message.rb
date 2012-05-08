class ChatMessage < ActiveRecord::Base
  # Validations
  validates :sender_id, :presence => true
  validates :recipient_id, :presence => true
  validates :message, :presence => true

  # Callbacks
  before_validation :strip_inputs

  protected
  def strip_inputs
    message.strip! if message
  end
end
