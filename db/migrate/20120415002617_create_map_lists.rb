class CreateMapLists < ActiveRecord::Migration
  def change
    create_table :map_lists do |t|
      t.integer :tournament_id, null: false
      t.integer :map_id, null: false
      t.integer :map_order, null: false

      t.timestamps
    end
  end
end
