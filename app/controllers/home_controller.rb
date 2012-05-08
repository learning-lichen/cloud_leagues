class HomeController < ApplicationController
  skip_authorization_check

  def index
    if current_user && !current_user.chat_profile.nil?
      chat_id = current_user.chat_profile.chat_id
      recent_messages = Hash[ChatMessage.where(recipient_id: chat_id).group(:sender_id).maximum("id").sort.reverse]
      @recent_messages = []
      
      for i in 0..4
        if !recent_messages.keys[i].nil?
          key = recent_messages.keys[i]
          message = ChatMessage.find_by_id(recent_messages[key])
          chat_profile = ChatProfile.find_by_chat_id(key)
          user = chat_profile.nil? ? nil : chat_profile.user

          @recent_messages.push [user, message]
        end
      end
    end
  end
end
