class AddActiveToBuds < ActiveRecord::Migration
  def change
    add_column :buds, :active, :boolean, default: false
  end
end
