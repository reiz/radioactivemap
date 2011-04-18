# == Schema Information
# Schema version: 20110406010754
#
# Table name: comments
#
#  id             :integer         not null, primary key
#  content        :string(240)     not null
#  measurement_id :integer
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Comment < ActiveRecord::Base

  attr_accessible :content

  belongs_to :user

  belongs_to :measurement

end