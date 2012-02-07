class AccountInformationsController < ApplicationController
  before_filter :authenticate, except: [:show]
  load_and_authorize_resource :user
  load_and_authorize_resource :account_information, through: :user, singleton: true

  def show
  end
  
  def new
  end

  def create
    user_role = :new_member unless current_user.account_information
    user_role ||= current_user.role
    @account_information = @user.build_account_information params[:account_information], as: user_role
    
    if @account_information.save
      flash[:notice] = 'Account information saved successfully.'
      redirect_to user_profile_path(@user)
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @account_information.update_attributes params[:account_information], as: current_user.role
      flash[:notice] = 'Profile information was updated successfully.'
      redirect_to user_profile_path(@user)
    else
      render action: :edit
    end
  end
  
  def destroy
    flash[:notice] = 'Account information deleted.'
    @account_information.destroy
    redirect_to user_path(@user)
  end
end
