# == Schema Information
#
# Table name: buds
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  uid         :string(255)
#  hardware_v  :string(255)
#  firmware_v  :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  active      :boolean          default(FALSE)
#  building_id :integer
#

class Bud < ActiveRecord::Base
	attr_accessible :name, :uid, :hardware_v, :firmware_v, :active, :building_id, :circuits_attributes, :remove
	has_many :circuits, dependent: :destroy
	accepts_nested_attributes_for :circuits, allow_destroy: true
	belongs_to :building
	has_many :followed_users, through: :building
	validates :name, length: { maximum: 50 }
	validates_presence_of :name, on: :update
	validates_uniqueness_of :uid, case_sensitive: false
	validates :uid, presence: true
	default_scope order: 'buds.created_at ASC'

	#needs building id for belongs_to
	#validates :building_id, presence: true
	#might want to know: last packet, heart beat... unless accessed through children

    normalize_attribute :remove

	def remove
  		# !self.building_id.nil?
	end

	def remove= bool
  		update_attribute :building_id, nil if (bool =='1')
	end

	def managers
		self.followed_users
	end
end
