# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    user nil
    session nil
    payment_id "MyString"
    state "MyString"
    amount "MyString"
    description "MyString"
  end
end
