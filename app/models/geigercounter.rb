class Geigercounter < ActiveRecord::Base

  attr_accessible :name, :tolerance, :manufacturer, :url, :filename

  validates :user_id, :presence => true

  validates :name, :presence      => true,
                   :uniqueness    => true,
                   :length        => { :within => 2..50 }

  validates :tolerance, :presence  => true,
                        :numericality => { :greater_than => 0, :less_than_or_equal_to => 100 }

  belongs_to :user

end