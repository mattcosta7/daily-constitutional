class Todo < ActiveRecord::Base
  belongs_to :user
  validates :description, presence: true
  validates :duedate, presence: true
end
