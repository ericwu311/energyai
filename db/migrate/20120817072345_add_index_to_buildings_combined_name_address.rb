class AddIndexToBuildingsCombinedNameAddress < ActiveRecord::Migration
	def change
		add_index :buildings, [:name, :address], unique: true
	end
end
