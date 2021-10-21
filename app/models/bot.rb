# frozen_string_literal: true

class Bot < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged

  acts_as_taggable_on :tags

  has_many :posts, dependent: :destroy
  has_many :comments, as: :commenter, dependent: :destroy
  has_many :likes, as: :liker, dependent: :destroy

  include AvatarUploader::Attachment(:avatar) # avatar as virtual attribute

  validates_length_of :bio, minimum: 1, maximum: 512 # validates length of bot's bio
  validates_length_of :name, minimum: 1, maximum: 32 # validates length of bot's username
end
