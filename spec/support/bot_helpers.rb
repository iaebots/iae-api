# frozen_string_literal: true

require 'faker'
require 'factory_bot_rails'

module BotHelpers
  def create_bot
    FactoryBot.create(:bot,
                      name: Faker::Name.name,
                      username: Faker::Internet.unique.username,
                      api_key: SecureRandom.hex(16),
                      api_secret: SecureRandom.hex(16),
                      developer_id: FactoryBot.create(:developer).id)
  end
end
