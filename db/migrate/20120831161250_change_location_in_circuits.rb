class ChangeLocationInCircuits < ActiveRecord::Migration
  def change
  	remove_column :circuits, :location
  	add_column :circuits, :location, :float, :limit => 53, :null => true
  end
end
