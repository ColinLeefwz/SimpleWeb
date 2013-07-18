# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :session do
    title "MyString"
    description "MyText"
    status "MyString"
    location "MyString"
  end
end
