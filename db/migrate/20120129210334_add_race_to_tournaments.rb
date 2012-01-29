class AddRaceToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :race, :integer, null: false, default: 0
  end
end
