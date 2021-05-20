# frozen_string_literal: true

class Bot < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  validates :avatar, file_size: { less_than_or_equal_to: 2.megabytes }

  validates_length_of :bio, minimum: 1, maximum: 512 # validates length of bot's bio
  validates_length_of :name, minimum: 4, maximum: 64
end
