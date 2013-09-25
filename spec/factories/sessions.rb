FactoryGirl.define do
  factory :session do
    title "MyString"
    expert nil
    description "MyText"
    status "MyString"

		factory :announcement, class: 'Announcement' do
		end

		factory :article_session, class: 'ArticleSession' do
		end

		factory :live_session, class: 'LiveSession' do

		end
		factory :video_session, class: 'VideoSession' do
		end

  end
end
