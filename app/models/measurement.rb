# == Schema Information
# Schema version: 20110406010754
#
# Table name: measurements
#
#  id         :integer         not null, primary key
#  name       :string(200)     not null
#  content    :string(240)     not null
#  lat        :float
#  lon        :float
#  msph       :float
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Measurement < ActiveRecord::Base

  attr_accessible :content, :msph, :lat, :lon

  belongs_to :user

  has_many :comments, :dependent => :destroy

  validates :content, :presence => true, :length => { :maximum => 240 }
  validates :user_id, :presence => true

  default_scope :order => 'measurements.created_at DESC'

  # Return measurements from the users being followed by the given user.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  before_save :create_random_name

  def to_param
    name
  end

  def sievert
    " " if self.msph.nil?
    "#{self.msph} microSv/h" if !self.msph.nil?
  end

  def as_json(options = {})
    {
        :content => self.content,
        :msph => self.msph,
        :lat => self.lat,
        :lon => self.lon,
        :user_img_link => self.user.image_url,
        :username => self.user.username,
        :userfullname => self.user.fullname,
        :creationdate => self.created_at
    }
  end

  def spoken_measurement
    message = self.user.fullname + " measured " + self.msph.to_s + " Mikrosievert"
    message += " with Geiger " + self.user.geigercounter.name unless self.user.geigercounter.nil?
    message
  end

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
        30.times { self.name << chars[rand(chars.size)] }
    end

end
