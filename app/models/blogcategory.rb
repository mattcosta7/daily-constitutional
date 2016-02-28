class Blogcategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :blog

  validates :category_id, presence: true
  validates :blog_id, presence: true
end
