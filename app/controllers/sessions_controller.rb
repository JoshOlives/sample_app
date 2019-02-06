class SessionsController < ApplicationController
  def new
  end
  #REFACTOR THIS CODE!!!!!!!!!!!!!
  #authenticate (has_sec_pass) and authenticated (custome)
  def create
    #making instance variable to implement in users_login test
    # used by using assigns(:user) for virtual attr
    @user = User.find_by(email: params[:session][:email].downcase)
    if logged_in? && current_user != @user && @user && @user.authenticate(params[:session][:password])
      flash[:warning] = 'please log out to access another account'
      redirect_to root_path
      # should i put remember/forget line here?
      return
    elsif logged_in? # if current_user = @user or @user is not in database
      redirect_to current_user
      params[:session][:remember_me] == '1' ? remember(current_user) : forget(current_user)
      return
    end
    if (@user && @user.authenticate(params[:session][:password]))
      if @user.activated?
        log_in(@user) #not logged in unless activated
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      # this if statement is the same as
      #params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or @user #short for user_path(user)
      else
        message = 'Account not activated. '
        message += 'Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_path
        #@user.send_activation_email doesnt work cause virtual attr
        #they are gone after one action
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new' #post url the same as get url
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
