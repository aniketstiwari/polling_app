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
      records = User.select('users.email, groups.name').where(id: leader_ids).joins(:groups).group(:email,'groups.name')
      leader_records = records.flat_map{|d| [{ group_name: d.name, leader_email: d.email }] }
      records.each do |record|
        UserMailer.notify_leaders(record[:leader_email], record[:group_name], event).deliver
      end
      user_ids = user_ids - leader_ids
      user_records = User.select('users.email, CONCAT(users.first_name, users.last_name) as leader_name, groups.name').where(id: user_ids).joins(:groups).group(:email,:leader_name, 'groups.name')
      filter_records = user_records.flat_map{|d| [{ group_name: d.name, email: d.email, leader_name: d.leader_name }] }
      filter_records.each do |filter_record|
        UserMailer.notify_users(filter_record[:email], filter_record[:group_name], filter_record[:leader_name], event).deliver
      end
    end## end of if
  end
end