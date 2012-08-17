# == Schema Information
#
# Table name: microalerts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Microalert < ActiveRecord::Base
	attr_accessible :content
	belongs_to :user
	self.per_page = 10   #paginate variable that declares number of alerts to list

	validates :content, presence: true, length: { maximum: MAX_MICROALERT_LENGTH }
	validates :user_id, presence: true

	default_scope order: 'microalerts.created_at DESC'

		# returns microposts from the users being
  	def self.from_users_followed_by(user)
  		# followed_user_ids = user.followed_user_ids # initial code loads all id's into memory
  		followed_user_ids = "SELECT followed_id FROM user_user_relationships 
  						     WHERE follower_id = :user_id"
  		where("user_id in (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
 	end

end
