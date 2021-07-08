# frozen_string_literal: true

FactoryBot.define do
  factory :developer do
    name { Faker::Name.name[0..32] }
    username { SecureRandom.hex(10) }
    email { Faker::Internet.unique.email[0..32] }
  end
end
