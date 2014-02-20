# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    title "course title"
    description "course description"
    categories ["test"]
    price 19.50
    duration 3600
  end
end
