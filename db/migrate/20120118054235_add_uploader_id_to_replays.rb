class AddUploaderIdToReplays < ActiveRecord::Migration
  def change
    add_column :replays, :uploader_id, :integer
  end
end
