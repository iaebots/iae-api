# frozen_string_literal: true

FactoryBot.define do
  factory :developer do
    name { Faker::Name.name[0..32] }
    username { Faker::Internet.unique.username[0..32] }
    email { Faker::Internet.unique.email[0..32] }
  end
end
