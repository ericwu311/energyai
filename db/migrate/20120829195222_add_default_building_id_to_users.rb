class AddDefaultBuildingIdToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :default_building_id, :integer
  end
end
