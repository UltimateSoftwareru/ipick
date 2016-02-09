class AddOrderRelationToComplainInsteadOfDeal < ActiveRecord::Migration
  def change
    remove_column :complains, :deal_id, :integer
    add_column :complains, :order_id, :integer
  end
end
