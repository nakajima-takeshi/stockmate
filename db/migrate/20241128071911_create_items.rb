class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.integer :user_id
      t.string :name
      t.integer :volume
      t.integer :used_count_per_day
      t.text :memo

      t.timestamps
    end
  end
end
