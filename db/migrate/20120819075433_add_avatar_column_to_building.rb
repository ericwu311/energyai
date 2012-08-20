class AddAvatarColumnToBuilding < ActiveRecord::Migration
  def change
  	add_column :buildings, :avatar, :string
  end
end
