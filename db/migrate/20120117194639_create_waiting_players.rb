class CreateWaitingPlayers < ActiveRecord::Migration
  def change
    create_table :waiting_players do |t|
      t.integer :tournament_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :player_accepted, :null => false, :default => false

      t.timestamps
    end
  end
end
