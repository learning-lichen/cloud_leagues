class AddGameNumberToReplay < ActiveRecord::Migration
  def change
    add_column :replays, :game_number, :integer
  end
end
