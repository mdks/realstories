class Story < ActiveRecord::Base
  acts_as_voteable
  belongs_to :user
  validates_presence_of :body
end
