class AddDealUniqIndex < ActiveRecord::Migration
  def change
    add_index :deals, [:order_id, :user_id], unique: true, name: :uniq_deals
  end
end
