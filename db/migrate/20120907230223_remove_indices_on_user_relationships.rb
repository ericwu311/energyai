class RemoveIndicesOnUserRelationships < ActiveRecord::Migration
  def up
	remove_index "user_relationships", :name => "index_user_bldg_relationships_on_followed_id_and_followed_type"
	remove_index "user_relationships", :name => "index_user_bldg_relationships_on_follower_id_and_followed_id", :unique => true
	remove_index "user_relationships", :name => "index_user_bldg_relationships_on_follower_id"
	add_index :user_relationships, :follower_id
	add_index :user_relationships, [:followed_id, :followed_type]
	add_index :user_relationships, [:follower_id, :followed_id, :followed_type], unique: true, name: 'unique_user_relation'
  end

  def down
	remove_index :user_relationships, :follower_id
	remove_index :user_relationships, [:followed_id, :followed_type]
	remove_index :user_relationships, [:follower_id, :followed_id, :followed_type], unique: true, name: 'unique_user_relation'
  end
end
