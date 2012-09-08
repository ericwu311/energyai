class CreateUserBldgRelationships < ActiveRecord::Migration
  def change
    create_table :user_bldg_relationships do |t|
      t.integer :follower_id
      t.integer :followed_id
	    t.string :followed_type
      t.timestamps
    end
  end
end
