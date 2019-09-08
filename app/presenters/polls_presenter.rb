class PollsPresenter
  attr_reader :response, :event, :yes_vote_count, :no_vote_count, :restaurants, :restaurant

  def initialize(user)
    @response = Response.new
    @event = Event.is_expire
    @restaurants = Restaurant.all if user.leader?
    @restaurant = Restaurant.new if user.leader?
    @yes_vote_count = Response.yes_count
    @no_vote_count = Response.no_count
  end
end