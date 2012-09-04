class Circuit < ActiveRecord::Base
  attr_accessible :name, :location, :side
  # side : left = 0, right = 1
  # location : group# . individual# double
  belongs_to :bud
  validates :bud_id, presence: true
  validates :name, presence: true
end