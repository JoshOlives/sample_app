class StaticPagesController < ApplicationController
  before_action :delete_url
  def home
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
  def log_in
  end
  
  def delete_url
    delete_store
  end
end
