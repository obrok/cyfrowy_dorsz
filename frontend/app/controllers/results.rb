class Results < Secured
  def index
    @question = Question[params[:question_id]]
    render
  end
end

