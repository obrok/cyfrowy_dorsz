class Answers < Application
  before :ensure_authenticated

  def index
    print "anwers | index"
    render
  end

  def check_token
    @token = Token[:value => params[:token]]
    print "answers | check_token"
    print token
  end

  def show
    print "answers | show"

  end

  def mysave
    print "answers | send"
    @poll = Poll[params[:id]]

  end

end

