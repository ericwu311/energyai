class Bud < ActiveRecord::Base
	attr_accessible :name, :uid, :hardware_v, :firmware_v, :active
	has_many :circuits, dependent: :destroy
	belongs_to :building
	validates :name, length: { maximum: 50 }
	validates_presence_of :name, on: :update
	validates_uniqueness_of :uid, case_sensitive: false
	validates :uid, presence: true
	default_scope order: 'buds.created_at ASC'
	#validates :building_id, presence: true

	#might want to know: last packet, heart beat, 
end