class PollsPresenter
  attr_reader :response, :event, :yes_vote_count, :no_vote_count

  def initialize(user)
    @response = Response.new
    @event = (user.admin? && Event.first.blank?) ? Event.new : Event.last
    @yes_vote_count = Response.response_yes_count
    @no_vote_count = Response.response_no_count
  end
end