class Questions < Application
  before :ensure_authenticated
  before :load_poll, :exclude => [:new]
  before :load_question, :exclude => [:new, :create]

  # GET /questions/new
  def new
    @question = Question.new
    render
  end

  def create
    @question = Question.new(params[:question] || {})
    begin
      @question.poll = @poll
      @question.save
      @status = 'succes'
    rescue Sequel::ValidationFailed
      @status = 'error'
    end
    render :layout => false
  end

  def edit
    render
  end

  def update
    @question.update(params[:question])
    redirect(resource(@poll, :edit))
  rescue Sequel::ValidationFailed
    render :new
  end

  def delete
    if @question.destroy
      redirect resource(@poll, :edit)
    else
      raise InternalServerError
    end
  end

  protected

  def load_poll
    @poll = session.user.polls_dataset.filter(:id => params[:poll_id]).first or raise NotFound
  end

  def load_question
    @question = @poll.questions_dataset.filter(:id => params[:id]).first or raise NotFound
  end
end

