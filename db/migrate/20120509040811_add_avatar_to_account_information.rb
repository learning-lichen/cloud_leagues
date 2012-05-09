class AddAvatarToAccountInformation < ActiveRecord::Migration
  def up
    change_table :account_informations do |t|
      t.has_attached_file :avatar
    end
  end

  def down
    drop_attached_file :account_informations, :avatar
  end
end
