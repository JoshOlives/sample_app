class SessionsController < ApplicationController
  def new
  end
  
  def create
    #making instance variable to implement in users_login test
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in(@user)
      if params[:session][:remember_me] == '1'
        remember @user
      else
        forget @user # really necessay wont all the keys by nill anyways?
      end
      # this if statement is the same as
      #params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to @user #short for user_path(user)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
