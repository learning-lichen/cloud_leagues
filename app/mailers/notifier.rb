class Notifier < ActionMailer::Base
  default from: "auto_support@cloud_leagues.com"
  default host: "cloudleagues.com"

  def deliver_password_reset_instructions(user)
    @user = user
    
    mail to: user.email, subject: "Cloud Leagues password reset."
  end
end
