# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'user@test.com'
    password 'password'
    first_name 'first_name'
    last_name 'last_name'

    factory :member, class: 'Member' do
      email "member@test.com"
      factory :expert, class: 'Expert' do
        email "expert@test.com"
        first_name 'expert_first_name'
        last_name 'expert_last_name'
      end
    end

    factory :admin_user, class: 'AdminUser' do
      first_name 'admin@test.com'
    end

  end
end
