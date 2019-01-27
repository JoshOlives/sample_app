module SessionsHelper
  #log in given user
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #returns the current logged-in user (if any)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end # finding this way to not throw error if nill but the if 
  end   # statement already does that doesnt it?
      #  is it possible for a not logged in user to have a session[:user_id]?
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end 