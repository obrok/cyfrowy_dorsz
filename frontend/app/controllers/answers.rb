class Answers < Application

  def index
    print "anwers | index"
    render
  end

  def check_token
    @token = Token[:value => params[:token]]
    if (@token != nil and not @token.used and @token.valid_until > DateTime::now)
      redirect url(:controller => "answers", :action => "show", :id => @token.poll.id)  
    else
      redirect url(:controller => "answers", :action => "index")
    end
  end

  def show
    print "answers | show"
    render
  end

  def mysave
    print "answers | send"
    @poll = Poll[params[:id]]

  end

end

