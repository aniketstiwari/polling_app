class Response < ApplicationRecord
  validates :vote, presence: true

  belongs_to :event
  belongs_to :user

  after_commit :notify_pusher, on: [:create, :update]
  
  def notify_pusher
    Pusher.trigger('response', 'new', self.as_json)
  end 
end
