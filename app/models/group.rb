class Group < ApplicationRecord
  belongs_to :leader, class_name: 'User'
  has_many :user_groups
  has_many :users, through: :user_groups

  class << self
    def group_division(user_ids)
      users_length = user_ids.length
      group_iteration = group_size = 0
      if(users_length > 4)
        (3..100).each do |num|
          if (users_length % num == 0 || users_length % num == 1)
            group_size = num
            break
          end
        end
      elsif users_length > 1
        group_size = users_length % 2
      elsif users_length == 1
        group_size = 1
      end
      return group_size
    end

    def create_dynamic_groups_array(user_ids, group_size)
      group_iteration = (user_ids.length) / group_size
      groups, leader_ids = Array.new(2) {[]}
      extra_group = (user_ids.length) % group_size
      group_iteration.times do |gi|
        group_member_ids = user_ids.first(group_size)
        leader_id = group_member_ids.sample
        leader_ids << leader_id
        if gi == group_iteration.size - 1
          groups << { size: group_size + extra_group, name: "group_" + self.generate_group_name, leader_id: leader_id }
        else
          groups << { size: group_size, name: "group_" + self.generate_group_name, leader_id: leader_id }
        end
        user_ids = user_ids - group_member_ids
      end
      return [groups, leader_ids]
    end

    def create_groups_and_user_groups(user_ids, groups)
      group_columns =  [:size, :name, :leader_id]
      user_groups = Group.import group_columns, groups
      groups = []
      group_size = user_ids.length/user_groups.ids.length
      group_id_index = 0
      user_ids.to_enum.with_index(1).each do |user_id, index|
        groups.push({group_id: user_groups.ids[group_id_index], user_id: user_id})
        group_id_index += 1 if index % group_size == 0
      end
      extra_group = (user_ids.length) % group_size
      groups.push({group_id: user_groups.ids.last, user_id: user_ids.last}) unless extra_group.zero?
      group_columns = [:user_id, :group_id]
      UserGroup.import group_columns, groups
    end

    def generate_group_name
      (0...10).map { ('a'..'z').to_a[rand(26)] }.join
    end
  end
end
