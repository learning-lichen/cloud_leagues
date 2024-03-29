class UserSessionsController < ApplicationController
  before_filter :authenticate, except: [:new, :create]
  load_and_authorize_resource

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      redirect_to root_path
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = 'You have been successfully logged out.'
    redirect_to root_path
  end
end
