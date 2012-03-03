class AddPrizeToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :prize, :integer, null: false, default: 0
  end
end
