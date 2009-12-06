class User < ActiveRecord::Base
  # vote_fu
  acts_as_voter
  # authlogic
  acts_as_authentic
  
  has_many :stories
  has_many :assignments
  has_many :roles, :through => :assignments
  
  validates_uniqueness_of :email
  validates_uniqueness_of :username, :case_sensitive => false
  
  # only these can be block-assigned
  attr_accessible :username, :email, :rpx_identifier
  
  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end
end
