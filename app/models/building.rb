# == Schema Information
#
# Table name: buildings
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  avatar     :string(255)
#


class Building < ActiveRecord::Base
	attr_accessible :address, :name, :avatar
	has_many :microalerts, as: :vocal, dependent: :destroy
	belongs_to :creator, class_name: "User", foreign_key: :creator_id
	
	mount_uploader :avatar, AvatarUploader

	validates :name, presence: true, length: { maximum: 50 }
	validates_uniqueness_of :name, scope: :address, case_sensitive: false
	validates :address, presence: true

	default_scope order: 'buildings.created_at DESC'
	# need to make an optional address identifier to bypass uniqueness limit
end
