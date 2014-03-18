# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video_interview do
    title "video interview title"
    expert
    categories ["test"]
    description "video interview description"
    video
  end
end
