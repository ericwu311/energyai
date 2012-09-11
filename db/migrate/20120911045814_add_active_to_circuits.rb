class AddActiveToCircuits < ActiveRecord::Migration
  def change
  	add_column :circuits, :active, :boolean
  end
end
