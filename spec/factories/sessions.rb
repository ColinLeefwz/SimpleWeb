# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :session do
    title "MyString"
    expert_id nil
    created_date "2013-07-18"
    description "MyText"
  end
end
