class CreateMicroalerts < ActiveRecord::Migration
  def change
    create_table :microalerts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :microalerts, [:user_id, :created_at]
  end
end
