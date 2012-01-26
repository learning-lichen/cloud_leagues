class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :tournament_id, :null => false
      t.integer :player_one_id, :null => false
      t.integer :player_two_id, :null => false
      t.boolean :player_one_accepts, :null => false, :default => false
      t.boolean :player_two_accepts, :null => false, :default => false
      t.integer :winner

      t.timestamps
    end
  end
end
