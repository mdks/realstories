class User < ActiveRecord::Base
  # vote_fu
  acts_as_voter
  # authlogic
  acts_as_authentic
  
  # no admins can be created when this is active
  # attr_protected :is_admin
  
  has_many :stories
  
  validates_uniqueness_of :email
  validates_uniqueness_of :username, :case_sensitive => false
  # only these can be block-assigned
  attr_accessible :username, :email, :rpx_identifier

end
