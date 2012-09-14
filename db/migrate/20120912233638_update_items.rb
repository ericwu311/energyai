class UpdateItems < ActiveRecord::Migration
  def change
  	add_column :items, :count, :integer
  	remove_column :items, :TypPower
  	remove_column :items, :unnamed
  end
end
