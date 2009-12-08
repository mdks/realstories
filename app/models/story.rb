class Story < ActiveRecord::Base
  acts_as_voteable

  belongs_to :user
  has_many :comments
  validates_presence_of :body, :title
  attr_accessible :body, :title
  cattr_reader :per_page
  @@per_page = 20

end
