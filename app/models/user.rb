class User < ActiveRecord::Base

  attr_accessor :password
  attr_accessible :fullname, :username, :email, :password


  validates :fullname, :presence      => true,
                       :length        => { :within => 2..50 }

  validates :username, :presence      => true,
                       :uniqueness    => true,
                       :length        => { :within => 2..50 }

  validates :email,    :presence    => true,
                       :length      => {:minimum => 5, :maximum => 254},
                       :uniqueness  => true,
                       :format      => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}

  validates :password, :presence      => true,
                       :length        => { :within => 5..40 }


  has_many :measurements, :dependent => :destroy

  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy

  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy

  has_many :following, :through => :relationships, :source => :followed

  has_many :followers, :through => :reverse_relationships, :source => :follower


  before_save :encrypt_password


  scope :admin, where(:admin => true)


  def to_param
    username
  end

  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, coockie_salt)
    user = find_by_id(id)
    ( user && user.salt == coockie_salt ) ? user : nil
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  def feed
    Measurement.from_users_followed_by(self)
  end

  private 

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def encrypt(string)
      p "#{salt}--#{string}"
      secure_hash("#{salt}--#{string}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end