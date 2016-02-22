class User < ActiveRecord::Base
  has_secure_password
  before_save :downcase_email
  has_many :todos, dependent: :destroy
  has_one :weather, dependent: :destroy
  has_many :reader_blogs
  has_many :blogs, through: :reader_blogs
  has_many :user_stars
  has_many :stars, through: :user_stars, source: :entry

  geocoded_by :location
  after_validation :geocode
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },uniqueness:{ case_sensitive: false }
  validates :password, presence: true,length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true,length: { minimum: 6 }, on: :create

  def coordinates
    [self.latitude,self.longitude]
  end

  def downcase_email
    self.email = email.downcase
  end 
end
