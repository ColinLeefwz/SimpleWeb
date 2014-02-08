FactoryGirl.define do
  factory :session do
    title "MyString"
    expert nil
    description "MyText"
    status "MyString"

		factory :article_session, class: 'Article' do
		end

		factory :live_session, class: 'LiveSession' do

		end

  end
end
