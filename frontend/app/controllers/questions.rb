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

      redirect(resource(@question.poll, :edit))
    rescue Sequel::ValidationFailed
      render :new
    end
  end

  def edit(id)
    @question = Question[:id =>id ] 
    @method = :put
    @action = resource(@question.poll, @question)
    render
  end

  def update
    puts "dupa"
    puts
    puts
    puts
    puts

    puts session.user.polls
    poll = session.user.polls_dataset[:id => params[:poll_id]]
    @question = poll.questions_dataset[:id=>params[:id]]
    begin
      raise NotFound unless @question
      @question.update(params[:question])

      redirect(resource(@question.poll, :edit))
    rescue Sequel::ValidationFailed
      render :new
    end
  end

  def delete(id)
    @question = Question[:id =>id ]    
    poll = @question.poll

    raise NotFound unless @question  
    if @question.destroy
      redirect resource(poll, :edit)  
    else
      raise InternalServerError
    end
  end
end

