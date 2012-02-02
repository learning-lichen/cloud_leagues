class RemoveFieldsFromMatches < ActiveRecord::Migration
  def up
    remove_column :matches, :player_one_id
    remove_column :matches, :player_two_id
    remove_column :matches, :player_one_accepts
    remove_column :matches, :player_two_accepts
    remove_column :matches, :contested
    rename_column :matches, :winner, :winner_id
  end

  def down
    add_column :matches, :player_one_id, null: false
    add_column :matches, :player_two_id, null: false
    add_column :matches, :player_one_accepts, null: false, default: false
    add_column :matches, :player_two_accepts, null: false, default: false
    add_column :matches, :contested, null: false, default: false
    rename_column :matches, :winner_id, :winner
  end
end
