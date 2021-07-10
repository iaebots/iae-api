# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    body { Faker::Games::Minecraft.achievement[0..32] }
    bot_id { FactoryBot.create(:bot).id }
  end
end
