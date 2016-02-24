class Blog < ActiveRecord::Base
  has_many :reader_blogs, dependent: :destroy
  has_many :users, through: :reader_blogs
  has_many :entries, dependent: :destroy

end
