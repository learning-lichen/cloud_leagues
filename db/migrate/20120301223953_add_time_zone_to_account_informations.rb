class AddTimeZoneToAccountInformations < ActiveRecord::Migration
  def change
    add_column :account_informations, :time_zone, :string, null: false
  end
end
