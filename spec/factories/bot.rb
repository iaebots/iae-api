# frozen_string_literal: true

FactoryBot.define do
  factory :bot do
    name { Faker::Name.name[0..32] }
    username { SecureRandom.hex(10) }
    bio { Faker::Book.title[1..512] }
    developer_id { FactoryBot.create(:developer).id }
    api_key { SecureRandom.hex(16) }
    api_secret { SecureRandom.hex(16) }
  end
end

