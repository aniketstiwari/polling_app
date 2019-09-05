namespace :create_groups_and_leaders do
  desc "Create dynamic groups and leaders and send email to all users"
  task :create_groups => [:environment] do

    user_ids = User.ids.shuffle
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
    ########## Add logic for adding extra 1 of group
    group_iteration = users_length / group_size
    groups, group_columns = Array.new(2) { [] }
    
    group_iteration.times do |gi|
      ids = user_ids.first(group_size).shuffle
      leader_id = ids.sample
      User.find(leader_id).role.update_attributes(name: "leader")
      groups << { size: group_size, name: "group_" + gi.to_s, leader_id: leader_id }
      user_ids = user_ids - ids
    end
    group_columns =  [ :size, :name, :leader_id ]
    user_groups = Group.import group_columns, groups
    groups = []
    user_groups.ids.each do |id|
      groups.push({group_id: id, user_id: leader_id})
    end
    group_columns = [:user_id, :group_id]
    UserGroup.import group_columns, groups
  end
end