class CreateBldgRelationships < ActiveRecord::Migration
  def change
    create_table :bldg_relationships do |t|
      t.integer :follower_id
      t.integer :followed_id
	  t.string  :followed_type
      t.timestamps
    end

    add_index :bldg_relationships, :follower_id
    add_index :bldg_relationships, [:followed_id, :followed_type]
    add_index :bldg_relationships, [:follower_id, :followed_id, :followed_type], unique: true, name: 'uniquify_each_relation'
  end
end
