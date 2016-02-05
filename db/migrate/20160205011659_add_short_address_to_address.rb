class AddShortAddressToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :short_address, :string
  end
end
