class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def test
    render html: "test"
  end
  
  def hello
    render html: "hi"
  end
  
  include SessionsHelper
  
  private
  
  def logged_in_user
    unless logged_in?
      store_location #only works with edit? cause only for gets not patches
      flash[:danger] = "please log in."
      redirect_to login_url
    end
  end
  
end