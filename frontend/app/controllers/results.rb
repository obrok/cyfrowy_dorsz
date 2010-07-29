class Results < Secured
  def index
    user = User[params[:teacher_id]]
    @question = Question[params[:question_id]]
    if user
      @answers = @question.question_answers_for_user(user)
    else
      @answers = @question.question_answers
    end
    render
  end
end

