 
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
  	def self.from_users_followed_by(vocal)
  		# followed_user_ids = user.followed_user_ids # initial code loads all id's into memory
  		followed_user_ids = "SELECT followed_id FROM relationships 
  						     WHERE follower_id = :user_id"
  		vocal_type = "User"
  		where("vocal_type = '#{vocal_type}' AND (vocal_id in (#{followed_user_ids}) OR vocal_id = :user_id)", user_id: vocal.id)
 	end

end
