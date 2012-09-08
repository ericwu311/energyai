 
# Table name: microalerts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  vocal_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  vocal_type :string(255)
#


class Microalert < ActiveRecord::Base
	attr_accessible :content
	belongs_to :vocal, :polymorphic => true

	self.per_page = 10   #paginate variable that declares number of alerts to list

	validates :content, presence: true, length: { maximum: MAX_MICROALERT_LENGTH }
	validates :vocal_id, presence: true
	validates :vocal_type, presence: true

	default_scope order: 'microalerts.created_at DESC'

	# returns microalerts from the users being
  	def self.from_users_followed_by(vocal_follower)
  		vocal_type = "User"
		if vocal_follower.is_a?(User)
	  		# followed_user_ids = user.followed_user_ids # initial code loads all id's into memory
	  		followed_user_ids = "SELECT followed_id FROM user_relationships 
	  						     WHERE follower_id = :user_id AND followed_type = :vocal_type"
	  		where("vocal_type = '#{vocal_type}' AND (vocal_id in (#{followed_user_ids}) OR vocal_id = :user_id)", user_id: vocal_follower.id, vocal_type: vocal_type)
	  	else 
	  		followed_user_ids = "SELECT followed_id FROM bldg_relationships
	  							 WHERE follower_id = :building_id AND followed_type = :vocal_type"
			where("vocal_type = '#{vocal_type}' AND (vocal_id in (#{followed_user_ids}))", building_id: vocal_follower.id, vocal_type: vocal_type)
	  	end		
 	end

 	def self.from_buildings_followed_by(vocal_follower)
 		vocal_type = "Building"
 		if vocal_follower.is_a?(User)
	  		# followed_user_ids = user.followed_user_ids # initial code loads all id's into memory
	  		followed_bldg_ids = "SELECT followed_id FROM user_relationships 
	  						     WHERE follower_id = :user_id AND followed_type = :vocal_type"
	  		where("vocal_type = '#{vocal_type}' AND (vocal_id in (#{followed_bldg_ids}))", user_id: vocal_follower.id, vocal_type: vocal_type)
	  	else 
	  		followed_bldg_ids = "SELECT followed_id FROM bldg_relationships 
	  						     WHERE follower_id = :building_id AND followed_type = :vocal_type"
	  		where("vocal_type = '#{vocal_type}' AND (vocal_id in (#{followed_bldg_ids}) OR vocal_id = :building_id)", building_id: vocal_follower.id, vocal_type: vocal_type)
  		end	
 	end

	def self.from_all_followed_by(follower)
		if follower.is_a?(User)
			followed_user_ids = "SELECT followed_id FROM user_relationships
								WHERE follower_id = :user_id AND followed_type = :user_type"
		    followed_bldg_ids = "SELECT followed_id FROM user_relationships 
	  						     WHERE follower_id = :user_id AND followed_type = :building_type"
	  		where("(vocal_type = :user_type AND (vocal_id in (#{followed_user_ids}) OR vocal_id = :user_id))
	  				OR (vocal_type = :building_type AND vocal_id in (#{followed_bldg_ids}))", 
	  				user_type: "User", user_id: follower.id, building_type: "Building")
	  	else
	  		followed_user_ids = "SELECT followed_id FROM bldg_relationships
								WHERE follower_id = :building_id AND followed_type = :user_type"
		    followed_bldg_ids = "SELECT followed_id FROM bldg_relationships 
	  						     WHERE follower_id = :building_id AND followed_type = :building_type"
	  		where("(vocal_type = :user_type AND vocal_id in (#{followed_user_ids}))
	  				OR (vocal_type = :building_type AND (vocal_id in (#{followed_bldg_ids}) OR vocal_id = :building_id))", 
	  				user_type: "User", building_id: follower.id, building_type: "Building")
	  	end
	end

end
