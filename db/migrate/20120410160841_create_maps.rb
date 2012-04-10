class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :name, null: false, blank: false
      t.string :image_url, null: false, default: ""
      t.string :download_url, null: false, blank: false

      t.timestamps
    end
  end
end
