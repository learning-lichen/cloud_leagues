class AddImageToMap < ActiveRecord::Migration
  def up
    remove_column :maps, :image_url
    
    change_table :maps do |t|
      t.has_attached_file :image
    end
  end

  def down
    drop_attached_file :maps, :image
    add_column :maps, :image_url, :string, null: false
  end
end
