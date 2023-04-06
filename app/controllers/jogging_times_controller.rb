class JoggingTimesController < ApplicationController
  before_action :authenticate_user!, only: %i[create edit destroy index update]
  before_action :correct_user, only: %i[destroy edit update]

  def index
    if user_signed_in? && current_user.role == "user"
      @jogging_time = current_user.jogging_times.build
      @jogging_times = current_user.my_times
      weekly_report
      if params[:from_date].present? || params[:to_date].present?
        filter_jogging_times
      end
    end
  end

  def create
    parameters = jogging_time_params.except(:from_date, :to_date)
    @jogging_time = current_user.jogging_times.build(parameters)
    if @jogging_time.save
      redirect_to root_url
    else
      @jogging_times = current_user.my_times
      weekly_report
      render "index"
    end
  end

  def edit
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

    def filter_jogging_times
      if params[:from_date].present?
        @from_date = Date.parse(params[:from_date])
      end
      if params[:to_date].present?
        @to_date = Date.parse(params[:to_date])
      end
      @jogging_times = @jogging_times
                      .where(date: (@from_date || Date.new)..(@to_date || Date::Infinity.new))
    end

    def weekly_report
      # Group jogging times by week
      grouped_jogging_times = @jogging_times.group_by { |j| j.date.strftime('%Y-%U') }

      # Calculate totals for each week
      @weeks = grouped_jogging_times.map do |week, jogging_times|
        avg_speed = 0
        jogging_times.each { |j| avg_speed += j.average_speed }
        avg_speed /= jogging_times.length

        start_date = Date.parse("#{week.split('-').first}-W#{week.split('-').last}-1")
        end_date = start_date + 6.days

        total_distance = jogging_times.sum(&:distance)
        { start_date: start_date, end_date: end_date, avg_speed: avg_speed.round(2), total_distance: total_distance }
      end
    end

end
