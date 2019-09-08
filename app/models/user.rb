class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :first_name, presence: true
  validates :department, presence: true

  has_one :role, dependent: :destroy
  has_one :event
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :user_restaurants
  has_many :restaurants, through: :user_restaurants

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

  def group_notified(user_id, restaurant_id)
    UserRestaurant.exists?(user_id: user_id, restaurant_id: restaurant_id)
  end

  def self.select_and_notify_leaders(leader_ids, event)
    records = self.select('users.email, groups.name').where(id: leader_ids).joins(:groups).group(:email,'groups.name')
      leader_records = records.flat_map{|d| [{ group_name: d.name, leader_email: d.email }] }
      leader_records.each do |leader_record|
        UserMailer.notify_leaders(leader_record[:leader_email], leader_record[:group_name], event).deliver
    end
  end

  def self.select_and_notify_users(user_ids, event)
    user_records = self.select('users.email, CONCAT(users.first_name, users.last_name) as leader_name, groups.name').where(id: user_ids).joins(:groups).group(:email, :leader_name, 'groups.name')
    filter_records = user_records.flat_map{|d| [{ group_name: d.name, email: d.email, leader_name: d.leader_name }] }
    filter_records.each do |filter_record|
      UserMailer.notify_users(filter_record[:email], filter_record[:group_name], filter_record[:leader_name], event).deliver
    end
  end

  def self.select_users_to_notify_for_restaurants(user)
    joins(:user_groups).joins(:groups).references(:user_groups).where('user_groups.group_id': user.groups.last.id).select('users.email, CONCAT(users.first_name, users.last_name) as leader_name ,groups.name ')
  end

  private

  def add_default_role
    self.create_role(name: "user")
  end
end
