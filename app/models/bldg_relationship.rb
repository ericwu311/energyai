class BldgRelationship < ActiveRecord::Base
  attr_accessible :followed_id, :followed_type

  belongs_to :follower, class_name: "Building"
  belongs_to :followed, :polymorphic => true

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :followed_type, presence: true
end
