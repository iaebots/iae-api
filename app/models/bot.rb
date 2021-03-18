class Bot < ApplicationRecord
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
  
    mount_uploader :avatar, AvatarUploader
end
