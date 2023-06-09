class JoggingTimesController < ApplicationController
  before_action :authenticate_user!, only: %i[create edit destroy index update]
  before_action :correct_user, only: %i[destroy edit update]

  def index
    if current_user.user?
      @jogging_time = current_user.jogging_times.build
      @jogging_times = current_user.my_times
      weekly_report
      filter_jogging_times if params[:from_date].present? || params[:to_date].present?
    elsif current_user.admin?
      @jogging_times = JoggingTime.reorder :id
    else
      redirect_to root_url
    end
  end

  def new
    redirect_to root_url unless current_user.admin?
    @users = User.pluck(:username, :id)
    @jogging_time = JoggingTime.new
  end

  def create

    if current_user.user?
      @jogging_time = current_user.jogging_times.build(jogging_time_params)
      if @jogging_time.save
        @jogging_times = current_user.my_times
        weekly_report
        respond_to do |format|
          format.html { redirect_to jogging_times_path }
          # format.json { head :no_content }
          format.js   {}
        end
      else
        @jogging_times = current_user.my_times
        weekly_report
        respond_to do |format|
          format.html { render :index }
          format.js   {}
        end
      end

    elsif current_user.admin?
      @jogging_time = JoggingTime.new jogging_time_params
      if @jogging_time.save
        respond_to do |format|
          format.html { redirect_to jogging_times_path }
          format.js   {}
        end
      else
        @users = User.pluck(:username, :id)
        respond_to do |format|
          format.html { render :new }
          format.js   {}
        end
      end

    else
      redirect_to root_url
    end
  end

  def edit
    @users = User.pluck(:username, :id) if current_user.admin?
  end

  def update
      if @jogging_time.update(jogging_time_params)
        respond_to do |format|
          format.html { redirect_to jogging_times_path }
          format.js   {}
        end
      else
        @users = User.pluck(:username, :id) if current_user.admin?
        respond_to do |format|
          format.html { render :edit }
          format.js   {}
        end
      end

  end

  def destroy
    @jogging_time.destroy
    @jogging_times = current_user.my_times
    weekly_report
    respond_to do |format|
      format.html { redirect_to request.referrer || jogging_times_path }
      # format.json { head :no_content }
      format.js   {}
    end
  end

  private

    def jogging_time_params
      params_list = %i[date distance hours minutes seconds]
      params_list += [:user_id] if current_user.admin?
      params.require(:jogging_time).permit(params_list)
    end

    def correct_user
      if current_user.user?
        @jogging_time = current_user.jogging_times.find_by(id: params[:id])
        redirect_to jogging_times_path if @jogging_time.nil?
      elsif current_user.admin?
        @jogging_time = JoggingTime.find_by(id: params[:id])
        redirect_to :back if @jogging_time.nil?
      elsif current_user.user_manager?
        redirect_to root_url
      end

    end

    def filter_jogging_times
      @jogging_times = @jogging_times.where(date: from_date..to_date)
    end

    def from_date
      @from_date ||= Date.parse(params[:from_date]) if params[:from_date].present?
    end

    def to_date
      @to_date ||= Date.parse(params[:to_date]) if params[:to_date].present?
    end

    def weekly_report
      # Group jogging times by week
      grouped_jogging_times = @jogging_times.group_by { |j| j.date.beginning_of_week }

      # Calculate totals for each week
      @weeks = grouped_jogging_times.map do |start_date, jogging_times|
        end_date = start_date + 6.days
        avg_speed = jogging_times.sum(&:average_speed) / jogging_times.length
        total_distance = jogging_times.sum(&:distance)

        { start_date: start_date, end_date: end_date, avg_speed: avg_speed.round(2), total_distance: total_distance }
      end
    end
end
