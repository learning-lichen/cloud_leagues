class UsersController < ApplicationController
  before_filter :authenticate, except: [:index, :show, :new, :create]
  load_and_authorize_resource

  def index
    @users = User.find :all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user], as: current_user ? current_user.role : :guest

    if @user.save
      redirect_to user_path(@user)
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes params[:user], as: current_user.role
      flash[:notice] = 'Update was successful.'
      redirect_to user_path(@user)
    else
      render action: :edit
    end
  end
  
  def destroy
    flash[:notice] = 'User has been deleted successfully.'
    current_user_session.destroy
    current_user.account_information.destroy if current_user.account_information
    current_user.destroy
    redirect_to root_path
  end
end
