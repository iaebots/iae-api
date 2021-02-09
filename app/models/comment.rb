class Comment < ApplicationRecord
  belongs_to :bot

  # Polymorphic comments
  belongs_to :commentable, polymorphic: true, optional: true
end
