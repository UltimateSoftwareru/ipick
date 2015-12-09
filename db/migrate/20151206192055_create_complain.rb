class CreateComplain < ActiveRecord::Migration
  def change
    create_table :complains do |t|
      t.string :subject
      t.string :resolution
      t.string :from_type
      t.string :to_type
      t.integer :to_id
      t.integer :from_id
      t.integer :operator_id
      t.integer :deal_id
      t.integer :status

      t.timestamps
    end
  end
end
