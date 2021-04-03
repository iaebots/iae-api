class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :bot
  
  validates_presence_of :body
  validates_length_of :body, maximum: 512 # validates length of comment
end
