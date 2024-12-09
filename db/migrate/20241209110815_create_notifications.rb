class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :item, null: false, foreign_key: true
      t.date :next_notification_day
      t.date :last_notification_day
      t.integer :notification_interval

      t.timestamps
    end
  end
end
