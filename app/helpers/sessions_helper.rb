module SessionsHelper
  #log in given user
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #returns the current logged-in user (if any)
  def current_user
    if (id = session[:user_id])
      @current_user ||= User.find_by(id: id)
    elsif (id = cookies.signed[:user_id])
      user = User.find_by(id: id)
      #so a logged in user doesnt get logged in again
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end # finding this way to not throw error if nill but the if 
  end   # statement already does that doesnt it?
      #  is it possible for a not logged in user to have a session[:user_id]?
  def logged_in?
    !current_user.nil?
  end
  
  def forget(user)
    cookies.delete(:user_id)# really no use to doing this
    user.forget
    cookies.delete(:remember_token)
  end
  
  def log_out
    forget(current_user) #why does this have to be first and why is @current_user nil at this stage?
    session.delete(:user_id) #does it have to do with destroy action?
    @current_user = nil
  end
  
  #not hacker proof if attacker has both cookies it can get access until logout!!
  #how to fix this???
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
end 