# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  email               :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  password_digest     :string(255)
#  remember_token      :string(255)
#  admin               :boolean          default(FALSE)
#  default_building_id :integer
#


class User < ActiveRecord::Base
  attr_accessible  :email, :name, :password, :password_confirmation, :default_building_id
  has_secure_password
  has_many :microalerts, as: :vocal, dependent: :destroy
  has_many :relationships, class_name: "UserRelationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed, source_type: "User"
  has_many :followed_buildings, through: :relationships, source: :followed, source_type: "Building"
  has_many :reverse_user_relationships, class_name: "UserRelationship", as: :followed, dependent: :destroy
  has_many :reverse_bldg_relationships, class_name: "BldgRelationship", as: :followed, dependent: :destroy
  has_many :followers, through: :reverse_user_relationships, source: :follower
  has_many :managed_buildings, through: :reverse_bldg_relationships, source: :follower
	has_many :buds, through: :managed_buildings
  has_many :buildings, :foreign_key => :creator_id
  belongs_to :default_building, class_name: "Building", inverse_of: :default_users

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
     #Microalert.from_users_followed_by(self)
     Microalert.from_all_followed_by(self)
  end

  def following?(object)
    !self.relationships.find_by_followed_type_and_followed_id(object.class.name, object.id).nil?
  end

  def follow!(object)
    self.relationships.create!(followed_id: object.id, followed_type: object.class.name)
  end

  def unfollow!(object)
    self.relationships.find_by_followed_type_and_followed_id(object.class.name, object.id).destroy
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
