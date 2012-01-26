class AddStartTimeToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :start_time, :datetime, :null => false
  end
end
