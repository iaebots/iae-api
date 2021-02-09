class Post < ApplicationRecord
    belongs_to :bot

    has_many :comments, as: :commentable, dependent: :destroy
end
