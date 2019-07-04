class UsersController < ApplicationController
  before_action :redirect_if_not_login, only: [:index, :show, :update, :edit, :destroy]
  before_action :correct_user, only: [:update, :edit]
  before_action :admin_user, only: :destroy

  def destroy
    if current_user.admin?
      User.find(params[:id]).destroy
      flash[:success] = "User Sucssesfully Deleted!"
      redirect_to users_url
    else
      flash[:danger] = "You are not a admin!"
      redirect_to users_url
    end
  end

  def index
    if params[:name].to_s != ''
      @searched_users = User.all.select { |user| user.name.start_with?(params[:name].to_s) || user.name.end_with?(params[:name].to_s)}
    end
    if @searched_users == nil || @searched_users == []
      if @searched_users == []
        flash[:danger] = "No users where found with that name or last name"
      end
      @users = User.paginate(page: params[:page])
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Successfully Updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
