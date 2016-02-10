class AddBodyToComplain < ActiveRecord::Migration
  def change
    add_column :complains, :body, :text
  end
end
