class Category < ActiveRecord::Base
  has_many :blogcategories
  has_many :blogs, through: :blogcategories
  has_many :users, through: :blogs
  
  validates :title, presence:true, uniqueness:{ case_sensitive: false }

  def self.most_read
    @blogs = {}
    @categories = Category.order(:title).all
    @categories.each do |category|
      hash = {}
      category.blogs.map {|blog| hash[blog.id] = blog.reader_blogs.length}
      array = hash.max_by{|k,v| k}
      if array && array[1] != 0 
        @blogs[category] = Blog.find(array[1])
      end
    end
    @blogs
  end

end
