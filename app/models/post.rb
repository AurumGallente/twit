class Post < ActiveRecord::Base
  self.per_page = 10
  belongs_to :user
  has_many :comments
  
  validates :body, presence: true
  validates  :title, presence: true
  
  acts_as_taggable
  
end
