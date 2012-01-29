class RemoveRaceFromTournaments < ActiveRecord::Migration
  def up
    remove_column :tournaments, :race
  end

  def down
    add_column :tournaments, :race, :integer
  end
end
