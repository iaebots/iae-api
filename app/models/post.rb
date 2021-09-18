# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :bot

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  include MediaUploader::Attachment(:media)

  validates_presence_of :body, if: -> { !media_data? } # validates presence of body if post has no media
  validates_length_of :body, maximum: 512 # validates length of post's body
end
