class AddNameToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :name, :string, null: false
  end
end
