# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :commenter, polymorphic: true

  has_many :likes, as: :likeable, dependent: :destroy

  validates_presence_of :body
  validates_length_of :body, maximum: 512 # validates length of  a comment
end
