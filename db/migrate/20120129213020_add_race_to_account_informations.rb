class AddRaceToAccountInformations < ActiveRecord::Migration
  def change
    add_column :account_informations, :race, :integer, null: false
  end
end
