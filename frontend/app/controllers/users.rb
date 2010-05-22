class Users < Application
  layout :anonymous

  def reset_password
    @token = params[:token]
    render
  end
end

