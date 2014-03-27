# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consultation do
    requester nil
    consultant nil
    description "MyString"
    status "MyString"
    price "9.99"
  end
end
