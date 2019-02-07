class PasswordResetsController < ApplicationController
  before_action :get_user,  only: [:edit]#, :update]
  before_action :get_user_update,  only: [ :update]
  before_action :valid_user,  only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

#url instead of path here cause the url is used in edit
  def edit
  end

  def create
    @user = User.find_by(email: params[:reset][:email].downcase)
    if @user
      @user.reset
      @user.send_password_reset_email
      flash[:info] = 'check email for password reset instructions'
      redirect_to root_path
    else
      flash.now[:danger] = 'email is not in database'
      render 'new'
    end
  end

  def update
    #only email is directly in params
    if params[:user][:password].empty? #automatically sends empty string wont be nil
      @user.errors.add(:password, "can't be empty") #how does the key play a role in this
      render 'edit'
    elsif @user.update_attributes(user_params)  #valid password
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "password reset"
      log_in(@user)
      redirect_to @user 
    else
      render 'edit' 
    end
  end
  
    private
    def get_user
      #changes according to what apple has saved?
      #in the upfdating process, overwriting it?
      @user = User.find_by(email: params[:email])
    end
    
    def get_user_update
      @user = User.find_by(email: params[:user][:email])
    end
    
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        flash[:warning] = 'please activate your account first or fix url'
        redirect_to root_path 
      end
    end
    
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = 'Password reset has expired.'
        redirect_to new_password_reset_path
      end
    end
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
