class UserMailer < Merb::MailController
  def reset_password
    @token = params[:user].login_token
    render_mail
  end  
end
