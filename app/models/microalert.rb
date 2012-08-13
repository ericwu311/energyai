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

end
