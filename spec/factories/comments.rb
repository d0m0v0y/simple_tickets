require 'ffaker'

FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.paragraph rand(1..10) }
    association :issue
  end
end
