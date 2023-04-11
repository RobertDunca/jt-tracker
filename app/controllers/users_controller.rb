class UsersController < ApplicationController
  before_action :authenticate_user!, :has_permission

  def index
    @users = User.all
  end

  def new
    @roles = [['User', :user], ['User manager', :user_manager], ['Admin', :admin]]
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path
    else
      @roles = [['User', :user], ['User manager', :user_manager], ['Admin', :admin]]
      render :new
    end
  end

  def edit
    @user = User.find_by id: params[:id]
    @roles = [['User', :user], ['User manager', :user_manager], ['Admin', :admin]]
  end

  def update
    @user = User.find_by id: params[:id]
    no_password
    if @user.update(user_params)
      @users = User.all
      redirect_to users_path
    else
      @roles = [['User', :user], ['User manager', :user_manager], ['Admin', :admin]]
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || users_path }
      # format.json { head :no_content }
      format.js   {}
    end
  end

  private

    def user_params
      params_list = %i[username email password password_confirmation]
      params_list += [:role] if current_user.admin?
      params.require(:user).permit(params_list)
    end

    def has_permission
      redirect_to(root_url) unless current_user.admin? || current_user.user_manager?
    end

    def no_password
      password = params[:user][:password]
      password_confirmation = params[:user][:password_confirmation]
      if password.blank? && password_confirmation.blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
    end

end
