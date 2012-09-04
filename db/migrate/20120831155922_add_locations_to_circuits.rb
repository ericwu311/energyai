class AddLocationsToCircuits < ActiveRecord::Migration
  def change
  	add_column :circuits, :location, :integer
  	add_column :buds, :building_id, :integer
  	add_index :buds, [:building_id, :created_at]
  end
end
