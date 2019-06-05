class UserProfile < ApplicationRecord
  belongs_to :user, :foreign_key => 'users_id'
  belongs_to :profile, :foreign_key => 'profiles_id'
end
