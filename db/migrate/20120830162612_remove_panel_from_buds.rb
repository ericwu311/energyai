class RemovePanelFromBuds < ActiveRecord::Migration
  def change
    remove_column :buds, :panel
  end
end
