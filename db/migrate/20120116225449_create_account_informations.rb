class CreateAccountInformations < ActiveRecord::Migration
  def change
    create_table :account_informations do |t|
      t.integer :user_id
      t.string :reddit_name
      t.string :character_name
      t.string :character_code
      t.string :chat_id

      t.timestamps
    end
  end
end
