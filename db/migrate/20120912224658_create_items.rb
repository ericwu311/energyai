class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
    	t.string :name
		t.integer :circuit_id
		t.string :status
      	t.timestamps
    end
  	add_index :items, [:circuit_id, :created_at]
  end
end
