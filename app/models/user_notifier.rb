class UserNotifier < ActionMailer::Base
  def forgot_password(user)
    setup_email(user)
    @subject    += ' - Reset Password'  
    @body[:url]  = "http://realstories.heroku.com/reset_password/#{user.reset_password_code}"
  end
  
  def activation_code(user)
    setup_email(user)
    @subject    += ' - Activation Code'  
    @body[:url]  = "http://realstories.heroku.com/activate/#{user.activation_code}"
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