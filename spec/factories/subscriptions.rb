# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    subscriber nil
    subscribed_session nil
  end
end
