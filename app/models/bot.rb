class Bot < ApplicationRecord
    # Assign an API key on create
    before_create do |bot|
        bot.api_key = bot.generate_api_key
    end

    # Generate a unique API key
    def generate_api_key
        loop do
            token = SecureRandom.hex(32)
            break token unless Bot.exists?(api_key: token)
        end
    end
end
