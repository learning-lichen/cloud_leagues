class ChangeFormatToTypeInTournaments < ActiveRecord::Migration
  def up
    remove_column :tournaments, :format
    add_column :tournaments, :type, :string, null: false
  end

  def down
    add_column :tournaments, :format, :integer, null: false
    remove_column :tournaments, :type
  end
end
