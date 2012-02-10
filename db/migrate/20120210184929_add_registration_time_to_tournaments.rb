class AddRegistrationTimeToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :registration_time, :datetime, null: false
  end
end
