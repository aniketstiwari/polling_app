class ResponsesController < ApplicationController
 
  def new
    @response = Response.new
  end

  def create
    @response = Response.new(response_params)
    @response.event_id = Event.last.id
    @response.user_id = current_user.id
   # respond_to do |format|
      if @response.save
        redirect_to polls_path, notice: 'response was successfully created.' 
        #format.json { render :show, status: :created, location: @response }
      else
        format.html { render :new }
        #format.json { render json: @response.errors, status: :unprocessable_entity }
      end
  #  end
    # if @response.save
    #   flash[:now] = "Response Created Successfully"
    #   redirect_to polls_path
    # else
    #   render :new
    # end
  end

  private

  def response_params
    params.require(:response).permit(:vote)
  end
end