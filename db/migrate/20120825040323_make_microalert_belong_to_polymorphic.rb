class MakeMicroalertBelongToPolymorphic < ActiveRecord::Migration
  def up
  	remove_index :microalerts, [:user_id, :created_at]
  	rename_column :microalerts, :user_id, :vocal_id
  	add_column :microalerts, :vocal_type, :string 
  	add_index :microalerts, [:vocal_id, :vocal_type, :created_at]
  end

  def down
  	remove_index :microalerts, [:vocal_id, :vocal_type, :created_at]
  	remove_column :microalerts, :vocal_type
  	rename_column :microalerts, :vocal_id, :user_id
  	add_index :microalerts, [:user_id, :created_at]
  end
end
