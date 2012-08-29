class AddCreatorToBuildings < ActiveRecord::Migration
  def change
  	add_column :buildings, :creator_id, :integer
  end
end
