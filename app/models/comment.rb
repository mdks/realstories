class Comment < ActiveRecord::Base
  belongs_to :story
  belongs_to :user
    
  has_rakismet :author => proc { user.username },
    :author_email => proc { user.email },
    :content_type => proc { 'comment' },
    :content => :body
    
  acts_as_voteable

  attr_accessible :body
  validates_presence_of :body
end
