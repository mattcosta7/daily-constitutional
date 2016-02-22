class Blog < ActiveRecord::Base
  has_many :reader_blogs
  has_many :users, through: :reader_blogs
  has_many :entries
end
