class User < ActiveRecord::Base
  has_secure_password
  before_save :downcase_email
  has_many :todos, dependent: :destroy
  has_one :weather, dependent: :destroy
  has_many :reader_blogs, dependent: :destroy
  has_many :blogs, through: :reader_blogs
  has_many :user_stars, dependent: :destroy
  has_many :stars, through: :user_stars, source: :entry
  has_many :entries, through: :blogs
  has_many :categories, through: :blogs
  geocoded_by :location
  after_validation :geocode, :if => lambda{ |user| user.location_changed? }
  
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

  def self.getTrains(user)
    state = Geocoder.search(user.location)[0].state
    # if state == "New York"
    #   return Apis::Mta.getNyc
    # elsif state == "Virginia"
    #   return Apis::Mta.getWdc
    # elsif state == "Massachuessets"
    #   return ["We Don't","Do Things", "In Boston, Yuck."]
    # elsif state == "Illinois"
    #   return Apis::Mta.getChicago
    # else
    #   nil
    # end
    if user.distance_to("New York City") == nil
      return [nil,nil,nil]
    elsif user.distance_to("New York City") < 50
      return Apis::Mta.getNyc
    elsif user.distance_to("Washington,DC") < 50
      return Apis::Mta.getWdc
    elsif user.distance_to("Boston") < 50
      return ["We Don't","Do Things", "In Boston, Yuck."]
    elsif user.distance_to("Chicago") < 50
      return Apis::Mta.getChicago
    else
      nil
    end
  end
end
