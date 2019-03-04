class User < ApplicationRecord
    default_scope -> { order(name: :asc) }
  
    has_many :microposts, dependent: :destroy
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id",
                                  dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id",
                                  dependent: :destroy
    #used followed_id as foreign key, automatically dependent since through?
    #not in database so dependent is not required
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships #, source: :follower optional
    
    #assigning attributes not in the database
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save :downcase_email # self keyword is optional on right hand side
    before_create :create_activation_digest
    
    validates :name, presence: true, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255}, 
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false }
    validates :password, length: {minimum: 6}, presence: true, allow_nil: true
    has_secure_password #only for sign up?               #excuse me??
    
    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    #returns a random token.
    def User.new_token
      SecureRandom.urlsafe_base64
    end
    
    def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest("#{remember_token}")) #unecessary can just put remember_token
    end
    
    # returns true if the given token matches the digest
    def authenticated?(att, token)
      #removing repetitive _digest
      digest = send("#{att}_digest") #send automatically puts self. in model
      if digest.nil?
        return false
      end
      BCrypt::Password.new(digest).is_password?(token)
    end
    
    # Forgets a user
    def forget
      update_attribute(:remember_digest, nil)
    end
    
    def activate
      #self. is automatic with update
      #diff between update_columns and update_attributes? both work
      update_columns(activated: true, activated_at: Time.zone.now)
    end
    
    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end
    
    # sets the passwrod reset attr
    def reset
        self.reset_token = User.new_token
        self.update_attributes(reset_digest: User.digest(reset_token),
                              reset_sent_at: Time.zone.now)
    end
    
    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
    end
    
    def password_reset_expired?
      reset_sent_at < 2.hours.ago
    end
    
    #tutorial feed, grabs from database, organizes all of them
  def feed
      #(following_ids = following.map(&:id)) == following_ids ;cause of active record
      #? does interpolation so you dont need to join array of ids into a string
   #more efficient cause doesnt have to pull everything into an array
   following_ids = "SELECT followed_id FROM relationships
                    WHERE follower_id = :user_id"
   Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", 
                      user_id: id)
  end
    
#    my feed, organizes them by time in packs, bad
#    def feed
#      feed = Micropost.where("user_id = ?", id)
      #changes activerecord to an array, how to make it remain active record
#      self.following.each do |f|
#       f_posts = Micropost.where("user_id = ?", f.id)
#        feed += f_posts
#      end
#      feed
#     end

    #remember about self
    #follows a user.
    def follow(other_user)
      following << other_user
    end
    
    #Unfollow a user
    def unfollow(other_user)
      following.delete(other_user)
    end
    
    def following?(other_user)
      following.include?(other_user)
    end
    
    def followed_by?(other_user)
      followers.include?(other_user)
    end
    
    
  def User.followjosh()
    a = User.find_by(email: "joshuaolivares@utexas.edu")
    User.all.each do |u|
      unless (u == a) || (u.following?(a))
        u.follow(User.find_by(email: "joshuaolivares@utexas.edu"))
      end
    end
  end
    
    private
      def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
      end
      
      def downcase_email
        email.downcase!
      end
      
end
