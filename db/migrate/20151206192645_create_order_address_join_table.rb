class CreateOrderAddressJoinTable < ActiveRecord::Migration
  def change
    create_join_table :orders, :addresses do |t|
      t.index [:order_id, :address_id]
    end
  end
end
