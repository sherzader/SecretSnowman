class UserMailer < ApplicationMailer
  default from: 'a/A Secret Snowman <aa.secret.snowman@gmail.com>'

  def welcome_email(user)
    @user = user
    # @url  = 'http://example.com/login'
    mail(to: "#{user.name} <#{user.email}>", subject: 'Welcome to a/A Secret Snowman')
  end

  def reminder_email(user)
    # ...
  end
  
end
