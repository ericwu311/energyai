# == Schema Information
#
# Table name: bldg_relationships
#
#  id            :integer          not null, primary key
#  follower_id   :integer
#  followed_id   :integer
#  followed_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class BldgRelationship < ActiveRecord::Base
  attr_accessible :followed_id, :followed_type

  belongs_to :follower, class_name: "Building"
  belongs_to :followed, :polymorphic => true

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :followed_type, presence: true
end
