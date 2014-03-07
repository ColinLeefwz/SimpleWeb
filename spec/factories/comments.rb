FactoryGirl.define do
  factory :comment do
    commentable_type "some_type"
    commentable_id 1
    content "comment content"
    user # belongs_to :user
  end
end
