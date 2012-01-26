class AddContestedToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :contested, :boolean, :null => false, :default => false
  end
end
