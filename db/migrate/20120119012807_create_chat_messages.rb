class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
      t.integer :sender_id, :null => false
      t.integer :recipient_id, :null => false
      t.string :message, :null => false
      t.boolean :read, :null => false, :default => false
      
      t.timestamps
    end
  end
end
