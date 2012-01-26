class AddRoleToAccountInformations < ActiveRecord::Migration
  def change
    add_column :account_informations, :role, :integer, :default => 0
  end
end
