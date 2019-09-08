class PollsPresenter
  attr_reader :response, :event, :yes_vote_count, :no_vote_count

  def initialize(user)
    @response = Response.new
    @event = Event.is_expire
    @yes_vote_count = Response.yes_count
    @no_vote_count = Response.no_count
  end
end