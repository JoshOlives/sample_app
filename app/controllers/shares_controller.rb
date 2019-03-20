class SharesController < ApplicationController
  
  before_action :logged_in_user
  #why do we need instance variables with ajax?
  
  
  def create
      @micropost = Micropost.find(params[:sharedpost_id])
      current_user.share(@micropost)
      flash[:success] = "Shared!"
      redirect_to request.referrer || root_url
  end
  
  def destroy
      @micropost = Share.find(params[:id]).sharedpost
      current_user.unshare(@micropost)
      flash[:success] = "Unshared"
      redirect_to request.referrer || root_url
  end
end
