class AddSideToCircuits < ActiveRecord::Migration
  def change
  	add_column :circuits, :side, :integer
  end
end
