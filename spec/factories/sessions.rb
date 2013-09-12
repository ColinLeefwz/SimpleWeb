# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :session do
    title "MyString"
    expert_id nil
    description "MyText"
    status "MyString"
  end
end
