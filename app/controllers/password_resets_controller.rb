class PasswordResetsController < ApplicationController
  skip_authorization_check
  before_filter :load_user_using_perishable_token, only: [:edit, :update]
  before_filter :require_no_user

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your passworld have been " + 
        "emailed to you. Please check your email."
      redirect_to root_path
    else
      flash[:notice] = "No user was found with that email address."
      render action: :new
    end
  end

  def edit
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save
      flash[:notice] = "Password successfully updated."
      redirect_to root_path
    else
      render action: :edit
    end
  end

  private
  def require_no_user
    return false unless current_user.nil?
  end

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "Sorry, we could not locate your account. " +
        "If you're having problems, trying pasting the URL from the email " +
        "into the address bar, or restarting to password reset process."
      redirect_to root_path
    end
  end
end
