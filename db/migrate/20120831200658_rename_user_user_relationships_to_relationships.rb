class RenameUserUserRelationshipsToRelationships < ActiveRecord::Migration
	def change
        rename_table :user_user_relationships, :relationships
    end
end
