class AddLeagueToAccountInformation < ActiveRecord::Migration
  def change
    add_column :account_informations, :league, :integer, null: false
  end
end
