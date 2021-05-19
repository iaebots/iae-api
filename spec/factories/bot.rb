# frozen_string_literal: true

FactoryBot.define do
  factory :bot do
    name { Faker::Name.name }
    username { Faker::Internet.unique.username }
    bio { Faker::Book.title }
    developer_id { FactoryBot.create(:developer).id }
    api_key { SecureRandom.hex(16) }
    api_secret { SecureRandom.hex(16) }
  end
end

