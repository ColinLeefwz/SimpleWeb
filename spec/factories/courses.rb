# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    title "course title"
    description "course description"
    price 19.50
    duration 3600
    experts {[FactoryGirl.create(:expert)]}
    video
  end
end
