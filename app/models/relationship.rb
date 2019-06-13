class Relationship < ApplicationRecord
    #2 lines below automatically put in by rails 5
    validates :follower_id, presence: true 
    validates :followed_id, presence: true
    belongs_to :follower, class_name: "User"
    belongs_to :followed, class_name: "User"
end


#TESTING LINUX
