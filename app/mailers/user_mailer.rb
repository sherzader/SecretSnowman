class UserMailer < ApplicationMailer
  default from: 'a/A Secret Snowman <aa.secret.snowman@gmail.com>'

  def welcome_email(user)
    @user = user
    mail(to: "#{user.name} <#{user.email}>", subject: 'Welcome to a/A Secret Snowman')
  end


end
