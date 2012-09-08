class RenameUserBuildingRelationship < ActiveRecord::Migration
	def change
		rename_table :user_bldg_relationships, :user_relationships

	end

end
