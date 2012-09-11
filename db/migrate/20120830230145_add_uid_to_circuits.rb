class AddUidToCircuits < ActiveRecord::Migration
  def change
  	add_column :circuits, :uid, :string
  end
end
