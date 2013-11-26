# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    title "MyString"
    company "MyString"
    expertise "MyText"
    favorite_quote "MyText"
    career "MyText"
    education "MyText"
    web_site "MyText"
    article_reports "MyText"
    additional "MyText"
    testimonials "MyText"
  end
end
