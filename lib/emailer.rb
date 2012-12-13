class Emailer < ActionMailer::Base
  def send_mail(name,body)
    mail(:subject => name,
      :to =>['yuan_xin_yu@hotmail.com','huang123qwe@126.com'],
      :from => 'huang123qwe@126.com',
      :date => Time.now,
      :body => body
    )
  end
end