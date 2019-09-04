class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :first_name, presence: true
  validates :department, presence: true

  has_one :role
  has_one :event

  after_create :add_default_role

  def user_role
    role.try(:name)
  end

  def admin?
    user_role == "admin"
  end

  def leader?
    user_role == "leader"
  end

  def user?
    user_role == "user"
  end

  def response_exists?(user, event_id)
    Response.exists?(user_id: user.id, event_id: event_id)
  end

  private

  def add_default_role
    self.create_role(name: "user")
  end
end
