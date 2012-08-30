# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#


class User < ActiveRecord::Base
  attr_accessible  :email, :name, :password, :password_confirmation, :default_building_id
  has_secure_password
  has_many :microalerts, as: :vocal, dependent: :destroy
  has_many :user_user_relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :user_user_relationships, source: :followed
  has_many :reverse_user_user_relationships, foreign_key: "followed_id",
                                     class_name: "UserUserRelationship", 
                                     dependent: :destroy
  has_many :followers, through: :reverse_user_user_relationships, source: :follower
	has_many :buildings, :foreign_key => :creator_id
  belongs_to :default_building, class_name: "Building", foreign_key: :default_building_id

	# before_save { |user| user.email = email.downcase }
  before_save { self.email.downcase! }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
      			    format: { with: VALID_EMAIL_REGEX }, 
  			        uniqueness: { case_sensitive: false }
  validates :password, presence: true,
                       length: { within:  6..40 },
                       :if => :should_validate_password?
  validates :password_confirmation, presence: true, :if => :should_validate_password?
 
  def feed
     # Microalert.from_buildings_followed_by(self) 
     # Microalert.where("user_id = ?", id)
     Microalert.from_users_followed_by(self)
  end

  def following?(other_user)
    self.user_user_relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    self.user_user_relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    self.user_user_relationships.find_by_followed_id(other_user.id).destroy
  end

  def created_buildings
    self.buildings
  end
  
  def recent_buildings
    # need to create a better algorithm for this
    self.buildings
  end

  def custom_update_attributes(params)
    if params[:password].blank?
      params.delete :password
      params.delete :password_confirmation
    end
    update_attributes params
  end

  private

    def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end

    def should_validate_password?
      new_record? || !password.blank?
    end
    
end
