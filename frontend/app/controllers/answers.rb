class Answers < Application
  layout :anonymous
  
  def index
    render
  end

  def show(values = nil)

    @token = Token[:value => params[:token]] unless params[:token] == nil
    @token = Token[:value => params[:id]] unless params[:id] == nil

    if (@token !=nil and @token.is_valid_to_use)
      message[:notice] = "Witamy w sesji"
      render
    else
      message[:error] = "Nieważny token"
      redirect url(:controller => "answers", :action => "index"), :message => message
    end
  end

  def save_answer
    @token = Token[:value => params[:token]]

    if (@token == nil or not @token.is_valid_to_use)
      message[:error] = "Nieważny token"
      redirect url(:controller => "answers", :action => "index"), :message => message
    end

    answer = Answer.new
    answer.token = @token
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

    @token.save

    render
  rescue Sequel::ValidationFailed
    render :show
  end

end

