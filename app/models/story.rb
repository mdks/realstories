class Story < ActiveRecord::Base
  acts_as_voteable

  belongs_to :user
  has_many :comments
  has_many :chapters
  has_many :pages, :through => :chapters
  validates_presence_of :body, :title
  attr_accessible :body, :title, :disable_commenting, :disable_voting
  cattr_reader :per_page
  @@per_page = 20

end
