namespace :create_groups_and_leaders do
  desc "Create dynamic groups and leaders and send email to all users"
  task :create_groups => [:environment] do
    user_ids = User.where.not(confirmation_token: nil).ids.shuffle - Role.where(name: 'admin').pluck(:user_id)
    #user_ids = User.ids.shuffle - Role.where(name: 'admin').pluck(:user_id)
    group_size = Group.group_division(user_ids)
    if group_size > 0
      groups, leader_ids = Group.create_dynamic_groups_array(user_ids, group_size)
      Role.change_role_to_leader(leader_ids)
      Group.create_groups_and_user_groups(user_ids, groups)
      event = Event.where(is_expire: "false").first
      User.select_and_notify_leaders(leader_ids, event)
      user_ids = user_ids - leader_ids
      User.select_and_notify_users(user_ids, event)
    end## end of if
  end
end