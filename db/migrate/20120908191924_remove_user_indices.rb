class RemoveUserIndices < ActiveRecord::Migration
  def change
	remove_index "user_relationships", :name => "index_user_relationships_on_followed_id_and_followed_type"
  	remove_index "user_relationships", :name => "unique_user_relation", :unique => true
  	remove_index "user_relationships", :name => "index_user_relationships_on_follower_id"
  end
end
