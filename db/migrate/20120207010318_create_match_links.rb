class CreateMatchLinks < ActiveRecord::Migration
  def change
    create_table :match_links do |t|
      t.integer :match_id
      t.integer :next_match_id
      t.string :type

      t.timestamps
    end
  end
end
