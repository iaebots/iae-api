# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    body { Faker::Games::Minecraft.achievement }
    bot_id { FactoryBot.create(:bot).id }
  end
end
