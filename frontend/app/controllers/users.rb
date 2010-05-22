class Users < Application
  layout :anonymous

  before :ensure_anonymous, :only => [:reset_password,
                                      :perform_reset_password,
                                      :request_reset_password,
                                      :send_reset_password
                                     ]

  before :prepare_token, :only => [:reset_password,
                                   :perform_reset_password
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

  def send_reset_password
    raise
  end

  private
  def prepare_token
    @token = params[:token]
    raise Forbidden unless @token && User[:login_token => @token]
  end
end

