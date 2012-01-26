class CreateChatProfiles < ActiveRecord::Migration
  def change
    create_table :chat_profiles do |t|
      t.integer :user_id, :null => false
      t.string :chat_id, :null => false

      t.timestamps
    end
  end
end
