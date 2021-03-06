# -*- coding: utf-8 -*-
class PossibleAnswers < Application
  
  before :ensure_authenticated
  before :ensure_not_blocked
  before :load_question
  before :ensure_can_manage

  def create
    @question.add_possible_answer(params[:answer])
    @question.save
    redirect resource(@question.poll, @question, :edit)
  rescue Sequel::ValidationFailed
    @poll = @question.poll
    @question_types = @question.load_question_types
    render :edit
  end

  def edit
  end

  def delete
    @question.possible_answers.delete_at(params[:answer_id].to_i)
    @question.save
    redirect resource(@question.poll, @question, :edit)
  end

  private

  def load_question
    @question = Question[params[:question_id]] or raise NotFound
  end

  def ensure_can_manage
    raise Forbidden unless @question.poll.user == session.user
  end
end

