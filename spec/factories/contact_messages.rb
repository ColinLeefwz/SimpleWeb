# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact_message do
    name "MyString"
    email ""
    message "MyText"
  end
end
