FactoryBot.define do
  factory :user do
    username     { 'User name' }
    email        { Faker::Internet.email }
    password     { 123456 }
    confirmed_at { Time.now }
    preferred_working_hours_per_day { 40 }
  end
end
