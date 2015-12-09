class CreateOrderTransportJoinTable < ActiveRecord::Migration
  def change
    create_join_table :orders, :transports do |t|
      t.index [:order_id, :transport_id]
    end
  end
end
