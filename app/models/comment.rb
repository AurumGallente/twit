class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  
  self.per_page = 10
end
