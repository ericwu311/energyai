class AddIndexToCircuits < ActiveRecord::Migration
  def change
  	add_index :circuits, [:bud_id, :created_at]
  end
end
