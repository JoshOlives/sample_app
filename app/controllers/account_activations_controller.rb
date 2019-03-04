class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = 'Account activated!'
      a = User.find_by(email: "joshuaolivares@utexas.edu")
      if !a.nil?
        user.follow(User.find_by(email: "joshuaolivares@utexas.edu"))
      end
      redirect_to user
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_path
    end
  end
end
