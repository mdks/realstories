class UserNotifier < ActionMailer::Base
  def welcome_user(user)
    setup_email(user)
    @subject    += ' - Welcome to RealStories'
  end

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "admin@realstories.heroku.com"
      @subject     = "realstories.heroku.com"
      @sent_on     = Time.now
      @body[:user] = user
    end
end