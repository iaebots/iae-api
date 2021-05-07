# frozen_string_literal: true

class Bot < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  validates :avatar, file_size: { less_than_or_equal_to: 2.megabytes }
end
