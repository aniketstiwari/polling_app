class ResponsesController < ApplicationController
 
  def new
    @response = Response.new
  end

  def create
    @response = Response.new(response_params)
    @response.event_id = Event.last.id
    @response.user_id = current_user.id
    if @response.save
      redirect_to polls_path, notice: 'Your vote is successfully submitted.'
    else
      render :new
    end
  end

  private

  def response_params
    params.require(:response).permit(:vote)
  end
end