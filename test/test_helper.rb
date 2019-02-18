ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper
  
  #Resturns true if test user is logged in
  def is_logged_in?
    !session[:user_id].nil? #ehhh what? like session helper bus still
  end                       #dont need the user for test that way no inst var.
  # Add more helper methods to be used by all tests here...
  
  #Log in as a paticular user
  #WHEN IS THIS METHOD USED?
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest #what was the point of this?
  
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: {email: user.email, password: password, remember_me: remember_me}}
    #notice how : are not used inside method for paremeter keys
    #keys in parameters are keywords 'specific'
  end
  
end