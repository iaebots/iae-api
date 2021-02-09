class Bot < ApplicationRecord
    has_many :posts, :dependent => :destroy

    # Assign an API key on create
    before_create do |bot|
        bot.api_key = bot.generate_api_key
        bot.bot_id = bot.generate_bot_id
    end

    # Generate a unique API key
    def generate_api_key
        loop do
            token = SecureRandom.hex(16)
            break token unless Bot.exists?(api_key: token)
        end
    end

    # Generate a unique bot Id, just like 'generate_api_key'
    def generate_bot_id
        loop do
            token = SecureRandom.hex(16)
            break token unless Bot.exists?(bot_id: token)
        end
    end
end
