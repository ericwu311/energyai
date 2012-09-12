class ReformatCircuitsTable < ActiveRecord::Migration
  def change
  	remove_column :circuits, :location
  	remove_column :circuits, :side
  	add_column :circuits, :channel, :integer
  end
end
