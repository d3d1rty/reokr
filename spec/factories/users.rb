# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    username { Faker::Internet.username.slice(0, 12) }
    password { Faker::Internet.password }

    after(:create) { |user| user.confirm }
  end
end
