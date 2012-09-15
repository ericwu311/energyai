# == Schema Information
#
# Table name: circuits
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bud_id     :integer
#  location   :float
#  side       :integer
#

class Circuit < ActiveRecord::Base
	#
	# => Circuit Mapping:
	# => Channels 0-2 (first 3) are voltages
	# => 3-31 circuits spi0
	# => 32-64 circuits spi1

  # status and active are overloaded right now, eventually move to just one
  # building id is used in the php but not rails
  attr_accessible :name, :channel, :active, :circuit_type_id, :status, :ip
  belongs_to :bud
  has_many :items, dependent: :destroy
  validates :bud_id, presence: true
  #validates :building_id, presence: true
  validates_presence_of :name, on: :update
  validates :channel, presence: true, numericality: { greater_than: -1, less_than: 65 }
  default_scope order: 'circuits.channel ASC'
end
