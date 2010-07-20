class Polls < Application
  before :ensure_authenticated
  before :load_poll, :only => [:edit, :stats]

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
    @action = resource(@poll, :questions)
    @method = :post
    @question = Question.new
    @question.poll = @poll

    if !@poll.contains_teacher_question
      @question_types = Question::TYPES.values
    else 
      @question_types = Array.new(Question::TYPES.values)
      @question_types.delete(Question::TYPES[:teacher])
    end

    raise NotFound unless @poll

    render
  end

  def stats
    @questions = @poll.questions_dataset.filter(:question_type => Question::TYPES[:closed])
    @answers = []
    @questions.each_with_index do |question, i|
      question.question_answers.each_with_index do |answer, j|
        unless @answers[j]
          @answers[j] = []
        end
        @answers[j][i] = answer
      end
    end
    render
  end



  protected

  def load_poll
    @poll = Poll[:id => params[:id]]
  end

end

