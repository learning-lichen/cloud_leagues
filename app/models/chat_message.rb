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

  def authorize
    current_user = UserSession.find.user
    chat_profile = ChatProfile.find_by_user_id(current_user.id)

    if current_user.role == AccountInformation::ADMIN
      # Admins can do anything, place no restriction on them.
      return true

    elsif current_user.role == AccountInformation::MODERATOR
      # Moderators can only read/unread their own messages.
      return true if new_record? && sender_id == chat_profile.chat_id && !read
      return true if read_status_changed? && recipient_id == chat_profile.chat_id
      return false

    else
      # Members can only read/uncread their own messages.
      return true if new_record? && sender_id == chat_profile.chat_id && !read
      return true if read_status_changed? && recipient_id == chat_profile.chat_id
      return false
    end
  end

  def read_status_changed?
    return false if new_record?
    chat_message = ChatMessage.find(id)

    return true if read != chat_message.read
    return false
  end
end
