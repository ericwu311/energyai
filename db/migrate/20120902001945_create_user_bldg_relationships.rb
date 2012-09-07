class CreateUserBldgRelationships < ActiveRecord::Migration
  def change
    create_table :user_bldg_relationships do |t|
      t.integer :follower_id
      t.integer :followed_id
	    t.string :followed_type
      t.timestamps
    end

    add_index :user_bldg_relationships, :follower_id
    add_index :user_bldg_relationships, [:followed_id, :followed_type]
    add_index :user_bldg_relationships, [:follower_id, :followed_id], unique: true, 
  end
end
