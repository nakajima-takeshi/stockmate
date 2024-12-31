class RenameUsedCountPerDayToUsedCountPerWeekly < ActiveRecord::Migration[7.2]
  def change
    rename_column :items, :used_count_per_day, :used_count_per_weekly
  end
end
