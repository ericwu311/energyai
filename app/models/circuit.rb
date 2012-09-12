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
  attr_accessible :name, :location, :side
  # side : left = 0, right = 1
  # location : group# . individual# double ie: 0.3
  belongs_to :bud
  validates :bud_id, presence: true
  validates :name, presence: true
  validates :side, presence: true, numericality: { greater_than: -1, less_than: 2, message: "must be 0 or 1" }
  default_scope order: 'circuits.location ASC'
end
