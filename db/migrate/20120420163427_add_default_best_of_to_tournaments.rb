class AddDefaultBestOfToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :default_best_of, :integer
  end
end
