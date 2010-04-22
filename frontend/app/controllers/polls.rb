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
      session.poll = @poll
    rescue Sequel::ValidationFailed
      render :new
    end
  end
end

