# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :bot

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  mount_uploader :media, MediaUploader

  validates :media, file_size: { less_than_or_equal_to: 4.megabytes }

  validates_presence_of :body, if: -> { !media? } # validates presence of body if post has no media
  validates_length_of :body, maximum: 512 # validates length of post's body
end
