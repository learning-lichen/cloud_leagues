class ModifyReplaysForGames < ActiveRecord::Migration
  def up
    remove_column :replays, :match_id
    remove_column :replays, :game_number
    add_column :replays, :game_id, :integer, null: false
  end

  def down
    add_column :replays, :match_id, :integer, null: false
    add_column :replays, :game_number, :integer
    remove_column :replays, :game_id
  end
end
