FactoryGirl.define do
  factory :article do
    title "MyString"
    description "MyText"
    categories ["test"]
    expert # belongs_to :expert
  end
end
