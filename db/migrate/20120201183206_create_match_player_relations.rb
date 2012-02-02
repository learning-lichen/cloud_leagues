class CreateMatchPlayerRelations < ActiveRecord::Migration
  def change
    create_table :match_player_relations do |t|
      t.integer :waiting_player_id, null: false
      t.integer :match_id, null: false
      t.boolean :accepted, default: false
      t.boolean :contested, default: false

      t.timestamps
    end
  end
end
