class Results < Application
  before :ensure_authenticated
  
  def index
    user = User[params[:teacher_id]]
    @question = Question[params[:question_id]]
    if user
      @answers = @question.question_answers_for_user(user)
    else
      @answers = @question.question_answers
    end

    if (@question.poll.contains_teacher_question?)
      @teachers = @question.poll.teacher_question.selectable_possible_answers
    else
      @teachers = []
    end

    render
  end
end

