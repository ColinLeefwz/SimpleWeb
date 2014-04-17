# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :followed do
    follower 
    followed 
  end
end

