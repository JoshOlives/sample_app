class MicropostsController < ApplicationController
    #skip_before_action :verify_authenticity_token, interesting
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user, only: :destroy
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path #redirect does goes through controller though
    else
      #@feed_items = [] crappy solution why is @microposts not forgetton?????
      render 'static_pages/home' #render doesnt go through controller method again
    end                         #straight to view??? what about @microposts?
  end                          #MAYBE CAUSE IT WAS POSTED, this is why render is meh
    #also fix home formatting
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
    #same as redirect_back(fallback_location: root_url)
    #request.referrer is the previous page
  end
  private
  
  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
