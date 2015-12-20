class ChangeDefaultStateMachineStatusForDeal < ActiveRecord::Migration
  def change
    change_column :deals, :status, :string, default: :in_progress
  end
end
