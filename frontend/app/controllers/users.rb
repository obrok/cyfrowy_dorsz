# -*- coding: utf-8 -*-
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

  before :ensure_authenticated, :only => [:profile,
                                          :update,
                                          :change_password,
                                         ]

  before :ensure_not_blocked, :only => [:profile,
                                          :update,
                                          :change_password,
                                       ]

  before :ensure_admin, :only => [:new,
                                  :create,
                                  :admin,
                                  :block,
                                  :unblock
                                 ]

  def new
    @user = User.new
    @user.blocked = false
    render :layout => :application
  end

  def create
    @user = User.new(params[:user].merge(:admin => false, :blocked => false))
    @user.randomize_password!
    @user.reset_password!
    redirect(resource(:users, :new), :notice => "Konto zostało utworzone")
  rescue Sequel::ValidationFailed
    render :new
  end

  def admin
    @users = User.filter(:admin => false)
    render :layout => :application
  end

  def block
    @user = User[:id => params[:id]]
    if not @user.admin? then
      @user.blocked = true
    end
    @user.save
    redirect(resource(:users, :admin))
  end

  def unblock
    @user = User[:id => params[:id]]
    if not @user.admin? then
      @user.blocked = false
    end
    @user.save
    redirect(resource(:users, :admin))
  end

  def profile
    @user = session.user
    render :layout => :application
  end

  def update
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
    if @user
      @user.reset_password!
      redirect(url(:login), :notice => "Wysłano email")
    else
      redirect(resource(:users, :request_reset_password), :error => "Nie ma takiego użytkownika")
    end      
  end

  def change_password
    @user = session.user
    if @user.authenticated?(params[:old_password])
      @user.password = params[:new_password]
      @user.password_confirmation = params[:new_password_confirmation]
      @user.save
      redirect(resource(:users, :profile), :notice => "Zmieniono hasło")
    else
      redirect(resource(:users, :profile), :error => "Niepoprawne hasło")
    end
  rescue Sequel::ValidationFailed
    redirect(resource(:users, :profile), :error => "Hasła różnią się")
  end

  private
  
  def prepare_token
    @token = params[:token]
    @user = User[:login_token => @token]
    raise Forbidden unless @token && @user
  end

  def ensure_admin
    ensure_authenticated
    raise Forbidden unless session.user.admin?
  end
end

