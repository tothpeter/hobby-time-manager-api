FactoryBot.define do
  factory :task do
    user
    title "MyString"
    description "MyText"
    date "2018-02-27"
    duration 1
  end
end
