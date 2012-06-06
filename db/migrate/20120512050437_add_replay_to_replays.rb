class AddReplayToReplays < ActiveRecord::Migration
  def up
    remove_column :replays, :replay_url

    change_table :replays do |t|
      t.has_attached_file :replay
    end
  end

  def down
    drop_attached_file :replays, :replay
    add_column :replays, :replay_url, :string, null: false
  end
end
