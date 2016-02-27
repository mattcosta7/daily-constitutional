class ReaderBlog < ActiveRecord::Base
  belongs_to :user
  belongs_to :blog

  validates :user_id, uniqueness: {scope: :blog_id}
  validates :blog_id, uniqueness: {scope: :user_id}
 
end
