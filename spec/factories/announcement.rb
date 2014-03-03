FactoryGirl.define do
  factory :announcement do
    title "announcement title"
    description "announcement description"
    categories ["test"]
    video
    expert
  end
end
