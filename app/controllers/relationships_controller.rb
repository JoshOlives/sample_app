class RelationshipsController < ApplicationController
    before_action :logged_in_user
    #why do we need instance variables with ajax?
    def create
        @user = User.find(params[:followed_id])
        current_user.follow(@user)
        #go over ajax
        #ajax makes it so its not a actual redirect. makes the request remote
        respond_to do |f|
            f.html { redirect_to @user} #if js disabled
            f.js
        end
    end
    
    def destroy
        #remember belongs to followed and follower
        @user = Relationship.find(params[:id]).followed
        current_user.unfollow(@user)
        respond_to do |f|
            f.html { redirect_to @user}
            f.js
        end
    end
end
