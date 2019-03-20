class Micropost < ApplicationRecord
  belongs_to :user
  has_many :shares, foreign_key: "sharedpost_id", dependent: :destroy
  has_many :sharers, through: :shares, source: :shared
  #creates a anonymous function in default_scope method?
  #is the proc called automatically when the method is ran?
  #go over taby ->
  #this is what orders the list when pagination occurs
  #gets post object and does post.order(created_at: :desc)}
  
  #with lambda it reavulates the scope each time its called
  #without it doesnt
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, length: {maximum: 140}, presence: true, if: Proc.new { |post| !post.picture? }
                                                                  # same as -> { !picture? }
                                                                  #automitically puts post object in front
  validate :picture_size
  
  def shared_by?(user)
    sharers.include?(user)
  end
  private
  
  #validates the size of an uploader picture.
  def picture_size
    if picture.size > 5.megabytes
      #go over errors.add method
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
