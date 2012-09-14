class UpdateCircuits < ActiveRecord::Migration
  def change
  	add_column :circuits, :circuit_type_id, :integer
  	add_column :circuits, :building_id, :integer
  	add_column :circuits, :status, :string
  	add_column :circuits, :ip, :string
  end
end
