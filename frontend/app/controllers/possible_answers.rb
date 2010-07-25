# -*- coding: utf-8 -*-
class PossibleAnswers < Secured
  before :load_question

  def create
    @question.add_possible_answer(params[:answer])
    @question.save
    redirect resource(@question.poll, @question, :edit)
  end

  def delete
    @question.possible_answers.delete_at(params[:answer_id].to_i)
    @question.save
    redirect resource(@question.poll, @question, :edit)
  end

  private
  def load_question
    @question = Question[params[:question_id]]

    raise NotFound unless @question
    raise Forbidden unless @question.poll.user == session.user
  end
end

