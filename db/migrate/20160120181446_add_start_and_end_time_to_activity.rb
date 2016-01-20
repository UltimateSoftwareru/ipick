class AddStartAndEndTimeToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :start, :datetime
    add_column :activities, :finish, :datetime
  end
end
