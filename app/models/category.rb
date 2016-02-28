class Category < ActiveRecord::Base
  has_many :blogcategories
  has_many :blogs, through: :blogcategories
end
