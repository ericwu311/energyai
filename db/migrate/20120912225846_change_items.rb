class ChangeItems < ActiveRecord::Migration
  def change
  	add_column :items, :device_id, :integer
  	add_column :items, :unnamed, :boolean
  	add_column :items, :TypPower, :float
  	add_column :items, :building_id, :integer
  end
end
