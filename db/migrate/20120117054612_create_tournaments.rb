class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.integer :league, :null => false, :default => 0
      t.integer :format, :null => false, :default => 0

      t.timestamps
    end
  end
end
