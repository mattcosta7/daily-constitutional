class UserStar < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry

  validates :user_id, uniqueness:  {scope: :entry_id}
  validates :entry_id, uniqueness:  {scope: :user_id}
end

