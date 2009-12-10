class Page < ActiveRecord::Base
  belongs_to :chapter
  attr_accessible :body
end
