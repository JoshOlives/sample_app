class User < ApplicationRecord
    attr_accessor :remember_token #assigning attribute cause not in database
    
    before_save { email.downcase! } # self keyword is optional on right hand side
    validates :name, presence: true, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255}, 
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false }
    validates :password, length: {minimum: 6}, presence: true
    has_secure_password
    
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
    def authenticated?(remember_token)
      if remember_digest.nil?
        return false
      end
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    
    # Forgets a user
    def forget
      update_attribute(:remember_digest, nil)
    end
end
