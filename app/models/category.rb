class Category < ActiveRecord::Base
  has_many :blogcategories
  has_many :blogs, through: :blogcategories
  has_many :users, through: :blogs
  
  validates :title, presence:true, uniqueness:{ case_sensitive: false }

#returns the blog with most readers in each category, as a hash
  def self.most_read
    @blogs = {}
    @categories = Category.order(:title).all
    @categories.each do |category|
      array = category.blogs.collect{|x| [x,x.users.length]}
      if array
        blog = array.max_by{|k,v| v}
        if blog
          @blogs[category.title] = blog
        end
      end
    end
    @blogs
  end

end
