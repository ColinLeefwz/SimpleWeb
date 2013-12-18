# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    title "MyTitle"
    description "MyText"
    categories "MyString"
  end
end
