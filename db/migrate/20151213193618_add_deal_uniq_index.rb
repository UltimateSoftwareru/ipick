class AddDealUniqIndex < ActiveRecord::Migration
  def change
    add_index :deals, [:order_id, :courier_id], unique: true, name: :uniq_deals
  end
end
