class Users < Application
  layout :anonymous

  before :ensure_anonymous, :only => [
                                      :reset_password,
                                      :perform_reset_password,
                                      :request_reset_password
                                     ]

  def reset_password
    @token = params[:token]
    render
  end

  def perform_reset_password
    raise
  end

  def request_reset_password
    raise
  end
end

