class ChangeIdNameForCircuits < ActiveRecord::Migration
  def change
  	add_column :circuits, :bud_id, :integer
  	remove_column :circuits, :uid
  end
end
