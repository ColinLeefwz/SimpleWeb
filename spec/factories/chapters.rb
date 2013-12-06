# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chapter do
    description "MyText"
    course nil
    order 1
  end
end
