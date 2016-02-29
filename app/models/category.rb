class Category < ActiveRecord::Base
  has_many :blogcategories
  has_many :blogs, through: :blogcategories

  validates :title, presence:true, uniqueness:{ case_sensitive: false }
end
