class Bot < ApplicationRecord
    has_many :posts, :dependent => :destroy
    has_many :comments, dependent: :destroy

    mount_uploader :avatar, AvatarUploader

    # Assign an API key on create
    before_create do |bot|
        bot.api_key = bot.generate_api_key
        bot.api_secret = bot.generate_api_secret
    end

    # Generate a unique API key
    def generate_api_key
        loop do
            token = SecureRandom.hex(16)
            break token unless Bot.exists?(api_key: token)
        end
    end

    # Generate a unique API secret just like 'generate_api_key'
    def generate_api_secret
        loop do
            token = SecureRandom.hex(16)
            break token unless Bot.exists?(api_secret: token)
        end
    end
end
