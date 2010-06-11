class Answers < Application

  def index
    render
  end

  def check_token
    @token = Token[:value => params[:token]]

    if (@token !=nil and @token.is_valid_to_use)
      message[:notice] = "Witamy w sesji"
      redirect url(:controller => "answers", :action => "show", :id => @token.value), :message => message
    else
      message[:notice] = "Nieważny token"
      redirect url(:controller => "answers", :action => "index"), :message => message
    end
  end

  def show(values = nil)
    @token = Token[:value => params[:id]]
    render
  end

  def save_answer
    @token = Token[:value => params[:token]]
    if (@token ==nil or not @token.is_valid_to_use)
      message[:notice] = "Nieważny token"
      redirect url(:controller => "answers", :action => "index"), :message => message
    end

    answer = Answer.new
    answer.date = DateTime.now
    answer.poll = @token.poll

    qas = []
    
    @token.poll.questions.each do |question|
      qa = QuestionAnswer.new
      qa.value = params[question.id.to_s]

      qa.question = question

      qas << qa
    end

    answer.save
    qas.each do |qa| 
      qa.answer = answer
      qa.save 
    end

    @token.used = true
    @token.save

    render
  end

end

