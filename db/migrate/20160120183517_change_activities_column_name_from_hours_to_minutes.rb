class ChangeActivitiesColumnNameFromHoursToMinutes < ActiveRecord::Migration
  def change
    rename_column :activities, :hours, :minutes
    remove_column :activities, :data, :datetime
    remove_column :activities, :deals_count, :integer
  end
end
