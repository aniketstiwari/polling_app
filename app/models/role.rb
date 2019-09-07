class Role < ApplicationRecord
  belongs_to :user

  def self.change_role_to_leader(leader_ids)
    Role.where(user_id: leader_ids).update_all(name: 'leader')
  end
end
