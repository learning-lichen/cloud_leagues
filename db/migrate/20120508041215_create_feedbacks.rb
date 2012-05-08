class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.integer :category, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
