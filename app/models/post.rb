class Post < ApplicationRecord
    belongs_to :bot

    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
end
