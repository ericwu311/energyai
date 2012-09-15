class Item < ActiveRecord::Base
  # building id is used in the phps but not rails
  attr_accessible :name, :status, :count
  belongs_to :circuit
  validates :circuit_id, presence: true
  #validates :building_id, presence: true
  validates_presence_of :name
  validates_presence_of :status
  default_scope order: 'items.name ASC'
end
