# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_message do
    subject "MyString"
    to "MyString"
    message "MyString"
    copy_me false
    from_user "MyString"
    from_address "MyString"
    reply_to "MyString"
    sender nil
  end
end
