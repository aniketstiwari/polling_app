class Restaurant < ApplicationRecord
  has_many :user_restaurants
  has_many :users, through: :user_restaurants

  mount_uploader :attachment, AttachmentUploader
  validates :name, presence: true
  validates :attachment, :presence => true
end
