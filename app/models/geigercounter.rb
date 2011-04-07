# == Schema Information
# Schema version: 20110406010754
#
# Table name: geigercounters
#
#  id           :integer         not null, primary key
#  name         :string(100)     not null
#  tolerance    :integer         default(25), not null
#  manufacturer :string(255)
#  url          :string(255)
#  filename     :string(255)
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

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
