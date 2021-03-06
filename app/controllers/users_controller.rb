class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :index, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  
  def new
    @user = User.new #why do i need this
  end
  def show
    @user = User.find(params[:id]) # id is what is after users/
    #return makes sure it doesnt go to view
    # will only show activated users
    #can make it so only activated users can look at others if 
    #i want by current_user.activated?
    
    #NOTE THE AND HERE
    redirect_to root_path and return unless @user.activated?
    #debugger                     #how can we make users non numbers.
                                   #in routes.RB probably
    @microposts = @user.microposts.paginate(page: params[:page])
  end                            
  
  def create
    @user = User.new(user_params) #what?
    if @user.save
      #log_in @user
      #flash[:success] = "Welcome :P"
      @user.send_activation_email
      flash[:info] = "please check your email to activate your account"
      redirect_to root_url #shorthand for user_url(@user) diff between url and path??
     else
      render 'new'
    end
  end
  
  def edit
    #failed edit does change url but :id is still there in url
  end

#updates password too prob want to make it so need previous password
  def update
    #why is @user not defined
    if @user.update_attributes(user_params)#not given!!!
      flash[:success] = "Changes saved"
      redirect_to @user
    else
      render 'edit'
      #diff between render and redirect? 
      #doesnt give errors cause treating error as .now
    end
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers 
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
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
  def index
    @users = User.where(activated: true).paginate(page: params[:page], per_page: 15)
  end
  
  def destroy
      name = User.find(params[:id]).name
      User.find(params[:id]).delete
      flash[:success] = "#{name} deleted"
      redirect_to users_path #render wont change url. no action
      name = nil
  end
  
  def admin_user
    unless current_user.admin?
      flash[:error] = "YOU CHEECKY BASTARD"
      redirect_to users_path
    end
  end
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation) #review this
    end
end
