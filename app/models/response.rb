class Response < ApplicationRecord

  scope :yes_count, -> { where(vote: "yes").count }
  scope :no_count, -> { where(vote: "no").count }

  validates :vote, presence: true

  belongs_to :event
  belongs_to :user

  after_commit :notify_pusher, on: [:create, :update]
  
  def notify_pusher
    Pusher.trigger('response', 'new', self.as_json)
  end 
end
