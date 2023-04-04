class JoggingTimesController < ApplicationController
  before_action :authenticate_user!, only: %i[create edit destroy home update]
  before_action :correct_user, only: %i[destroy edit update]

  def home
    if user_signed_in?
      @jogging_time = current_user.jogging_times.build
      @jogging_times = current_user.my_times
      if params[:jogging_time].present?
        start_date = Date.parse(params.require(:jogging_time).permit(:start_date))
        end_date = Date.parse(params.require(:jogging_time).permit(:end_date))
        @jogging_times = @jogging_times.where(date: start_date..end_date)
        redirect_to root_url
      end
    end
  end

  def create
    @jogging_time = current_user.jogging_times.build(jogging_time_params)
    if @jogging_time.save
      redirect_to root_url
    end
  end

  def edit
    p "#{@jogging_time.id}" + '++++++++++++'
  end

  def update
    if @jogging_time.update(jogging_time_params)
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def destroy
    @jogging_time.destroy
    redirect_to request.referrer || root_url
  end



  private

    def jogging_time_params
      params.require(:jogging_time).permit(:date, :distance, :hours, :minutes, :seconds)
    end

    def correct_user
      @jogging_time = current_user.jogging_times.find_by(id: params[:id])
      redirect_to root_url if @jogging_time.nil?
    end

end
