class AddDefaultStateMachineValues < ActiveRecord::Migration
  def change
    change_column :orders, :status, :string, default: :opened
    change_column :deals, :status, :string, default: :interested
  end
end
