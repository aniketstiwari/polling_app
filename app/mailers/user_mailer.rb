class UserMailer < ApplicationMailer
  def notify_leaders(leader_email, group_name, event)
    @group_name = group_name
    mail(to: leader_email, subject: "We have a #{event.event_type} on friday!. So, stay tuned")
  end

  def notify_users(user_email, group_name, leader_name, event)
    @group_name = group_name
    @leader_name = leader_name
    @event = event
    mail(to: user_email, subject: "We have a #{@event.event_type} on friday!. So, stay tuned")
  end

  def notify_leader_groups(user_email, leader_name, group_name)
    @group_name = group_name
    @leader_name = leader_name
    mail(to: user_email, subject: "Your #{@leader_name} has choose the restaurant")
  end
end
