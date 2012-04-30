class ChangeMessageToTextInChatMessage < ActiveRecord::Migration
  def up
    remove_column :chat_messages, :message
    add_column :chat_messages, :message, :text, null: false
  end

  def down
    remove_column :chat_messages, :message
    add_column :chat_messages, :message, :string, null: false
  end
end
