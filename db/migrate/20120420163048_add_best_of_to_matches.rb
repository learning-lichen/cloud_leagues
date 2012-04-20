class AddBestOfToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :best_of, :integer, null: false
  end
end
