class AddGenreToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :category, :string
  end
end
