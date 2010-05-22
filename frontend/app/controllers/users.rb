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
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @user.login_token = nil
    @user.save
    redirect(url(:login), :notice => "Hasło zmienione")
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
    @user = User[:login_token => @token]
    raise Forbidden unless @token && @user
  end
end

