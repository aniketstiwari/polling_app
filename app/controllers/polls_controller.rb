class PollsController < ApplicationController

  def index
    @presenter = PollsPresenter.new(current_user)
  end
end
