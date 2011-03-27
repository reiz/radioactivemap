class Measurement < ActiveRecord::Base

  attr_accessible :content, :msph, :lat, :lon

  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 240 }
  validates :user_id, :presence => true

  default_scope :order => 'measurements.created_at DESC'

  # Return measurements from the users being followed by the given user.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  before_save :create_random_name

  private

    # Return an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.followed_by(user)
      followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id", { :user_id => user })
    end

    def create_random_name
        chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
        self.name = ""
        62.times { self.name << chars[rand(chars.size)] }
    end

end