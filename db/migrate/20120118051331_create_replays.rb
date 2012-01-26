class CreateReplays < ActiveRecord::Migration
  def change
    create_table :replays do |t|
      t.integer :match_id, :null => false
      t.string :replay_url, :null => false

      t.timestamps
    end
  end
end
