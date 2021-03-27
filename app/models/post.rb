class Post < ApplicationRecord
    belongs_to :bot
    
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy

    mount_uploader :media, MediaUploader

    validates_presence_of :body, if: -> {!media?} # validates presence of post if has no media
    validates_length_of :body, maximum: 512 # validates length of post

end

