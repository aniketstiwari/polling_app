class RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render :new
    end
  end

  def notifyuser
    @restaurant = Restaurant.find(params["restaurant_id"])
    @restaurant.user_restaurants.create(user_id: current_user.id)
    User.select_users_to_notify_for_restaurants(current_user).each do |object|
      UserMailer.notify_leader_groups(object.email, object.leader_name, object.name).deliver
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :attachment)
  end
end