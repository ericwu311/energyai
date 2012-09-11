class Circuit < ActiveRecord::Base
	#
	# => Circuit Mapping:
	# => Channels 0-2 (first 3) are voltages
	# => 3-31 circuits spi0
	# => 32-64 circuits spi1
	#
  attr_accessible :name, :channel, :active
  belongs_to :bud
  validates :bud_id, presence: true
  validates_presence_of :name, on: :update
  validates :channel, presence: true, numericality: { greater_than: -1, less_than: 65 }
  default_scope order: 'circuits.channel ASC'
end