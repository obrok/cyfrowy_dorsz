# -*- coding: utf-8 -*-
class PossibleAnswers < Secured
  def create
    question = Question[params[:question_id]]

    raise NotFound unless question
    raise Forbidden unless question.poll.user == session.user

    question.possible_answers << params[:answer]
    question.save
    ""
  end
end

