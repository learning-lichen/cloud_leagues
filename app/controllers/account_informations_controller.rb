class AccountInformationsController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource :user
  load_and_authorize_resource :account_information, :through => :user, :singleton => true

  def new
  end

  def create
    @account_information = @user.build_account_information params[:account_information], :as => current_user.role
    
    if @account_information.save
      flash[:notice] = 'Account information saved successfully.'
      redirect_to user_profile_path(@user)
    else
      render :action =>:new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @account_information.update_attributes params[:account_information], :as => current_user.role
      flash[:notice] = 'Profile information was updated successfully.'
      redirect_to user_profile_path(@user)
    else
      render :action => :edit
    end
  end
  
  def destroy
    flash[:notice] = 'Account information deleted.'
    @account_information.destroy
    redirect_to user_path(@user)
  end
end
