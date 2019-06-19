class Share < ApplicationRecord
  validates :shared_id, presence: true
  validates :sharedpost_id, presence: true
  belongs_to :sharedpost, class_name: 'Micropost'
  belongs_to :sharer, class_name: 'User'
end
