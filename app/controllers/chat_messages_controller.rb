class ChatMessagesController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource

  def index
    chat_id = current_user.chat_profile.chat_id
    new_messages = Hash[ChatMessage.where(recipient_id: chat_id).group(:sender_id).maximum("id").sort.reverse]
    @messages = []

    new_messages.each do |key, val|
      chat_profile = ChatProfile.find_by_chat_id(key)
      message = ChatMessage.find_by_id(val)
      user = chat_profile.nil? ? nil : chat_profile.user

      @messages.push [user, message]
    end

    respond_to do |format|
      format.html { render :index }
      format.json { render json: { unread_messages: !ChatMessage.where(recipient_id: chat_id, read: false).empty? }.to_json }
    end
  end

  def show
    @message = @chat_message
    sender = @message.sender_id == current_user.chat_profile.chat_id ? @message.recipient_id : @message.sender_id
    recipient = @message.recipient_id == current_user.chat_profile.chat_id ? @message.recipient_id : @message.sender_id

    @messages = ChatMessage.where('(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)', sender, recipient, recipient, sender).order('id DESC').limit(100)
    @sender = ChatProfile.find_by_chat_id(sender).user rescue nil

    render

    @messages.each { |message| message.update_column :read, true if @message.recipient_id == current_user.chat_profile.chat_id }
  end

  def new
    @message = ChatMessage.new
    @message.sender_id = current_user.chat_profile.chat_id
  end

  def create
    if params[:chat_message] && params[:chat_message][:recipient_id]
      profile = ChatProfile.find_by_chat_id params[:chat_message][:recipient_id]

      if profile.nil?
        user = User.find_by_login params[:chat_message][:recipient_id]
        params[:chat_message][:recipient_id] = user.chat_profile.chat_id unless user.nil? || user.chat_profile.nil?
        params[:chat_message][:recipient_id] = nil if user.nil? || user.chat_profile.nil?
      end
    end
    
    @message = ChatMessage.new params[:chat_message]
 
    if @message.save
      flash[:notice] = 'Message sent.'
      redirect_to user_chat_message_path(current_user, @message)
    else
      flash[:notice] = 'Message could not be sent.'
      render action: :new
    end
  end

  def destroy
    @chat_message.destroy
    flash[:notice] = 'Message destroyed.'
    redirect_to user_chat_messages_path(current_user)
  end
end
