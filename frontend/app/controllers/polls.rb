class Polls < Application
  before :ensure_authenticated

  # provides :xml, :yaml, :js

  # GET /polls/new
  def new
    @poll = Poll.new
    render
  end

  def index
    @polls = session.user.polls
    render
  end

  # POST /polls
  def create
    @poll = Poll.new(params[:poll] || {})
    begin
      @poll.user = session.user
      @poll.save
      redirect(resource(@poll, :edit), :notice => "Stworzono ankietę " + @poll.name)
    rescue Sequel::ValidationFailed
      render :new
    end
  end

  def edit
    @poll = Poll[:id => params[:id]]
    @action = resource(@poll, :questions)
    @method = :post
    @question = Question.new
    @question.poll = @poll
    raise NotFound unless @poll

    render
  end

end

