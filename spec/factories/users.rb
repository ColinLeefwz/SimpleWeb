# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'email@test.com'
    password 'password'
    first_name 'first_name'
    last_name 'last_name'

    factory :member, class: 'Member' do
      factory :expert, class: 'Expert' do
        first_name 'expert@test.com'
      end
    end

    factory :admin_user, class: 'AdminUser' do
      first_name 'admin@test.com'
    end

  end
end
