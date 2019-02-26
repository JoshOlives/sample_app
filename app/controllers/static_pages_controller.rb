#required cause feed was changed from active record to array
require 'will_paginate/array' 
class StaticPagesController < ApplicationController
  before_action :delete_url
  def home
    if logged_in?
      #why do i have problem with @feed_items but not @microposts
      @micropost = current_user.microposts.build
      #@feed_items in feed partial to fix problem
    end
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
