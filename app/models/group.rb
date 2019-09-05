class Group < ApplicationRecord
  belongs_to :leader, class_name: 'User'
  has_many :user_groups
  has_many :users, through: :user_groups

end
