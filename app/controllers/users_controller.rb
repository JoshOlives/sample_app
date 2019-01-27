class UsersController < ApplicationController
  def new
    @user = User.new #why do i need this
  end
  def show
    @user = User.find(params[:id])
    #debugger
  end
  
  def create
    @user = User.new(user_params) #what?
    if @user.save
      log_in @user
      flash[:success] = "Welcome :P"
      redirect_to @user #shorthand for user_url(@user) diff between url and path??
     else
      render 'new'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation) #review this
    end
end
