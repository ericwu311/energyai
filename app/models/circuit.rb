class Circuit < ActiveRecord::Base
  attr_accessible :name
  belongs_to :bud
  validates :bud_id, presence: true
end