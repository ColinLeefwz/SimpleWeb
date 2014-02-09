FactoryGirl.define do
  factory :article do
    title "MyString"
    expert Expert.create(first_name: "gecko", last_name: "fu")
    description "MyText"
  end
end
