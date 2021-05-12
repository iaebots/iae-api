# frozen_string_literal: true

FactoryBot.define do
  factory :developer do
    name { Faker::Name.name }
    username { Faker::Internet.unique.username }
    email { Faker::Internet.unique.email }
  end
end
