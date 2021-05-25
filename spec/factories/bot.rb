# frozen_string_literal: true

FactoryBot.define do
  factory :bot do
    name { Faker::Name.name[0..32] }
    username { Faker::Internet.unique.username[0..32] }
    bio { Faker::Book.title[0..32] }
    developer_id { FactoryBot.create(:developer).id }
    api_key { SecureRandom.hex(16) }
    api_secret { SecureRandom.hex(16) }
  end
end

