# Read about factories at https://github.com/thoughtbot/factory_girl
require 'ffaker'

FactoryGirl.define do
  factory :issue do
    reporter_name { Faker::Name.name }
    reporter_email { Faker::Internet.email }
    association :department
    subject { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph 5 }
  end
end
