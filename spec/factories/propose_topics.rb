# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :propose_topic do
    Name "MyString"
    Location "MyString"
    Email "MyString"
    Topic "MyText"
  end
end
