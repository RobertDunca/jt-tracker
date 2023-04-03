class JoggingTimesController < ApplicationController
  before_action :authenticate_user!, only: %i[create edit destroy home]

  def home
    if user_signed_in?
      @time = current_user.jogging_times.build
      @jogging_times = current_user.jogging_times
    end
  end

  def create
    @jogging_time = current_user.jogging_times.build(jogging_time_params)
    if @jogging_time.save
      redirect_to root_url
    end
  end

  def edit
  end

  def destroy
  end

  private

    def jogging_time_params
      params.require(:jogging_time).permit(:date, :distance, :hours, :minutes, :seconds)
    end

end
