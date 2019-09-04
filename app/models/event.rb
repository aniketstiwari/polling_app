class Event < ApplicationRecord
  validates :event_type, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  belongs_to :user
  has_many :responses
end
