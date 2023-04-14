class UsersController < ApplicationController
  before_action :authenticate_user!, :has_permission
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :set_roles, only: [:new, :edit]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      respond_to do |format|
        format.html { redirect_to users_path }
        # format.json { head :no_content }
        format.js   {}
      end
    else
      set_roles
      respond_to do |format|
        format.html { render :new }
        # format.json { head :no_content }
        format.js   {}
      end
    end
  end

  def edit
    redirect_to users_path if @user.admin?
  end

  def update
    redirect_to users_path if @user.admin?
    no_password
    if @user.update(user_params)
      @users = User.all
      respond_to do |format|
        format.html { redirect_to users_path }
        format.js   {}
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js   {}
      end
    end
  end

  def destroy
    @user.destroy unless @user.admin?
    respond_to do |format|
      format.html { redirect_to request.referrer || users_path }
      # format.json { head :no_content }
      format.js   {}
    end
  end

  private

    def set_user
      @user = User.find_by(id: params[:id])
      redirect_to(root_url) if @user.nil?
    end

    def set_roles
      @roles = [['User', :user], ['User manager', :user_manager], ['Admin', :admin]]
    end

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
