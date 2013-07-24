# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :join_expert do
    Name "MyString"
    Location "MyString"
    Email "MyString"
    Expertise "MyText"
  end
end
