class RemoveDownloadUrlFromMaps < ActiveRecord::Migration
  def up
    remove_column :maps, :download_url
      end

  def down
    add_column :maps, :download_url, :string
  end
end
