class EventsController < ApplicationController

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      flash[:notice] = 'Event Created Successfully'
      redirect_to polls_path
    else
      render :new
    end
  end

  private

  def event_params
    params.require(:event).permit(:event_type, :start_date, :end_date)
  end
end