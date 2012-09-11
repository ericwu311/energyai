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
	#has_many :buds
	belongs_to :creator, class_name: "User", foreign_key: :creator_id
	has_many :default_users, class_name: "User", foreign_key: :default_building_id, inverse_of: :default_building
	has_many :relationships, class_name: "BldgRelationship", foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed, source_type: "User"
	has_many :followed_buildings, through: :relationships, source: :followed, source_type: "Building"
	has_many :reverse_user_relationships, class_name: "UserRelationship", as: :followed, dependent: :destroy
	has_many :reverse_bldg_relationships, class_name: "BldgRelationship", as: :followed, dependent: :destroy
	has_many :followers, through: :reverse_user_relationships, source: :follower
	has_many :follower_buildings, through: :reverse_bldg_relationships, source: :follower	

	mount_uploader :avatar, AvatarUploader

	validates :name, presence: true, length: { maximum: 50 }
	validates_uniqueness_of :name, scope: :address, case_sensitive: false
	validates :address, presence: true

	default_scope order: 'buildings.created_at DESC'
	# need to make an optional address identifier to bypass uniqueness limit

	def feed
		# Microalert.from_buildings_followed_by(self) 
		#Microalert.where("vocal_type = ? AND vocal_id = ?", self.class.name, id)
		#Microalert.from_buildings_followed_by(self)
		Microalert.from_all_followed_by(self)  
	end

	def following?(object)
		!self.relationships.find_by_followed_type_and_followed_id(object.class.name, object.id).nil?
	end

	def follow!(object)
		self.relationships.create!(followed_id: object.id, followed_type: object.class.name)
	end

	def unfollow!(object)
		self.relationships.find_by_followed_type_and_followed_id(object.class.name, object.id).destroy
	end	

	def managers
		self.followed_users
	end
end
