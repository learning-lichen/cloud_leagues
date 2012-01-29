class AddMaxPlayersToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :max_players, :integer, null: false, default: 20
  end
end
