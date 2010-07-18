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

  def profile
    @user = session.user
    render(:layout => :application)
  end

  def update
    puts "dupa"
    puts "dupa"
    puts "dupa"

    session.user.update(params[:user])

    redirect(resource(:users, :profile), :notice => "Dane zapisane")
  end

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
  rescue Sequel::ValidationFailed
    message[:notice] = "Hasła różnią się"
    render :reset_password
  end

  def request_reset_password
    render
  end

  def send_reset_password
    @user = User[:email => params[:email]]
    @user.reset_password! if @user
    redirect(url(:login), :notice => "Wysłano email")
  end

  private
  def prepare_token
    @token = params[:token]
    @user = User[:login_token => @token]
    raise Forbidden unless @token && @user
  end
end

