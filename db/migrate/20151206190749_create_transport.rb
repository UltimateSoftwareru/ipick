class CreateTransport < ActiveRecord::Migration
  def change
    create_table :transports do |t|
      t.string :name
    end
  end
end
