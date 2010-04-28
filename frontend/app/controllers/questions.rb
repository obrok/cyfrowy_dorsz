class Questions < Application
  before :ensure_authenticated

  # provides :xml, :yaml, :js

  # GET /questions/new
  def new
    @question = Question.new
    render
  end

  def create    
    @question = Question.new(params[:question] || {})
    begin
      @question.poll = Poll[params[:poll_id]]
      @question.save
    rescue Sequel::ValidationFailed
      render :new
    end
  end
end

