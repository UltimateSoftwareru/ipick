class CreateDeal < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :status, null: false, default: "in_progress"
      t.text :comment
      t.integer :order_id
      t.integer :user_id
      t.boolean :interested
      t.attachment :picture
      t.datetime :delivered_at
      t.timestamps
    end
  end
end
