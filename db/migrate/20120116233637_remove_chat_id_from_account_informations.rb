class RemoveChatIdFromAccountInformations < ActiveRecord::Migration
  def up
    remove_column :account_informations, :chat_id
  end

  def down
    add_column :account_informations, :chat_id, :integer
  end
end
