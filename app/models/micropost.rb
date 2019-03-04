class Micropost < ApplicationRecord
  belongs_to :user
  #creates a anonymous function in default_scope method?
  #is the proc called automatically when the method is ran?
  #go over taby ->
  #this is what orders the list when pagination occurs
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, length: {maximum: 140}, presence: true, if: Proc.new { |post| !post.picture? }
  validate :picture_size
  
  private
  
  #validates the size of an uploader picture.
  def picture_size
    if picture.size > 5.megabytes
      #go over errors.add method
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
