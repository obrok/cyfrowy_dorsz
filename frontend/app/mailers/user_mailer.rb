class UserMailer < BaseMailer
  def reset_password
    @token = params[:user].login_token
    render_mail
  end  
end
