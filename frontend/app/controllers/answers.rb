class Answers < Application

  def index
    render
  end

  def check_token
    @token = Token[:value => params[:token]]

    if (@token != nil and not @token.used and @token.valid_until > DateTime::now)
      message[:notice] = "Witamy w sesji"
      redirect url(:controller => "answers", :action => "show", :id => @token.value), :message => message
    else
      message[:notice] = "Nieważny token"
      redirect url(:controller => "answers", :action => "index"), :message => message
    end
  end

  def show
    @token = Token[:value => params[:id]]
    render
  end

  def mysave
    @poll = Poll[params[:id]]

  end

end

