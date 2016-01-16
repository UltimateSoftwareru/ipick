class AddDefaultValueToComplainStatus < ActiveRecord::Migration
  def change
    change_column :complains, :status, :string, null: false, default: "opened"
  end
end
