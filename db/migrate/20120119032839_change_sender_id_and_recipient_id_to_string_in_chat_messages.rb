class ChangeSenderIdAndRecipientIdToStringInChatMessages < ActiveRecord::Migration
  def up
    change_column :chat_messages, :sender_id, :string, :null => false
    change_column :chat_messages, :recipient_id, :string, :null => false
  end

  def down
    change_column :chat_messages, :sender_id, :integer, :null => false
    change_column :chat_messages, :recipient_id, :integer, :null => false
  end
end
