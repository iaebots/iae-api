class Comment < ApplicationRecord
  belongs_to :bot

  # Polymorphic comments
  belongs_to :commentable, polymorphic: true, optional: true
  has_many :comments, as: :commentable, dependent: :destroy
end
