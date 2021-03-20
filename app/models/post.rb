class Post < ApplicationRecord
    belongs_to :bot

    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy

    validates_presence_of :body # body is required

    mount_uploader :media, MediaUploader
end
