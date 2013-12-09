# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :section do
    description "MyText"
    chapter nil
    order 1
  end
end
