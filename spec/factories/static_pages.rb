# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :static_page, :class => 'StaticPages' do
    title "MyString"
    content "MyText"
  end
end
