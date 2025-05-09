# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  comments_count :integer
#  likes_count    :integer
#  private        :boolean
#  username       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class User < ApplicationRecord
  validates(:username, {
    :presence => true,
    :uniqueness => { :case_sensitive => false },
  })

  # Association accessor methods to define:
  
  ## Direct associations

  has_many(:comments, class_name:"Comment", foreign_key:"author_id", primary_key:"id")
  # User#comments: returns rows from the comments table associated to this user by the author_id column
  has_many(:own_photos, class_name:"Photo", foreign_key:"owner_id", primary_key:"id")
  # User#own_photos: returns rows from the photos table  associated to this user by the owner_id column
  has_many(:likes, class_name:"Like", foreign_key:"fan_id", primary_key:"id")
  # User#likes: returns rows from the likes table associated to this user by the fan_id column
  has_many(:follow_requests, class_name:"Follow_Request", foreign_key:"sender_id", primary_key:"id")
  # User#sent_follow_requests: returns rows from the follow requests table associated to this user by the sender_id column
  has_many(:received_follow_request, class_name:"Follow_Request", foreign_key:"recipient_id", primary_key:"id")
  # User#received_follow_requests: returns rows from the follow requests table associated to this user by the recipient_id column

  ## Scoped direct associations

  has_many(:accepted_sent_follow_requests, -> { where(status: "accepted") }, class_name:"Follow_Request", foreign_key:"sender_id")
  # User#accepted_sent_follow_requests: returns rows from the follow requests table associated to this user by the sender_id column, where status is 'accepted'
  has_many(:accepted_received_follow_requests, -> { where(status: "accepted") }, class_name:"Follow_Request", foreign_key:"recipient_id")
  # User#accepted_received_follow_requests: returns rows from the follow requests table associated to this user by the recipient_id column, where status is 'accepted'

  ## Indirect associations
  
  has_many(:liked_photos, through: :likes, source: :photo)
  # User#liked_photos: returns rows from the photos table associated to this user through its likes
  has_many(:commented_photos, through: :comments, source: :photo)
  # User#commented_photos: returns rows from the photos table associated to this user through its comments

  ## Indirect associations built on scoped associations

  # User#followers: returns rows from the users table associated to this user through its accepted_received_follow_requests (the follow requests' senders)

  # User#leaders: returns rows from the users table associated to this user through its accepted_sent_follow_requests (the follow requests' recipients)

  # User#feed: returns rows from the photos table associated to this user through its leaders (the leaders' own_photos)

  # User#discover: returns rows from the photos table associated to this user through its leaders (the leaders' liked_photos)
end
