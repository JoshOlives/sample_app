class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def new
    @user = User.new #why do i need this
  end
  def show
    @user = User.find(params[:id]) # id is what is after users/
    #debugger                     #how can we make users non numbers.
  end                             #in routes.RB probably
  
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
  
  def edit
    #failed edit does change url but :id is still there in url
  end

#updates password too prob want to make it so need previous password
  def update
    if @user.update_attributes(user_params)#not given!!!
      flash[:success] = "Changes saved"
      redirect_to @user
    else
      render 'edit'
      #diff between render and redirect? redirect doesnt give params?
    end
  end
  
  def logged_in_user
    unless logged_in?
      store_location #only works with edit? cause only for gets not patches
      flash[:danger] = "please log in."
      redirect_to login_url
    end
  end
  
  def correct_user
    @user = User.find params[:id] #follows id of user, params[:user][:id]
    unless current_user?(@user) 
      flash[:warning] = "No,no,no ;)"
      redirect_to root_path 
    end
  end
  #should i change it to @user???cause if entering restricted edit 
  #then logging into not that id for the restricted edit
  #that leads you to the home page not the profile nor edit page
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation) #review this
    end
end
