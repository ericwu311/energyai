class CreateCircuits < ActiveRecord::Migration
  def change
    create_table :circuits do |t|
      t.string :name
      
      t.timestamps
    end
  end
end
