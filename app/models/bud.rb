class Bud < ActiveRecord::Base
	attr_accessible :name, :uid, :hardware_v, :firmware_v
	#has_many: circuits
	#has_many: devices
	belongs_to :building
	validates :name, presence: true, length: { maximum: 50 }
	validates_uniqueness_of :uid, case_sensitive: false
	validates :uid, presence: true
end
