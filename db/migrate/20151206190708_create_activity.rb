class CreateActivity < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.date :data
      t.integer :courier_id
      t.integer :hours
      t.integer :deals_count
    end
  end
end
