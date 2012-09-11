class CreateBuds < ActiveRecord::Migration
  def change
    create_table :buds do |t|
      t.string :name
      t.string :panel
      t.string :uid
      t.string :hardware_v
      t.string :firmware_v

      t.timestamps
    end
  end
end
