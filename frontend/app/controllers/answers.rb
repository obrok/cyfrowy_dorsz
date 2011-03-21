# -*- coding: utf-8 -*-
class Answers < Application
  layout :anonymous
  
  def index
    render
  end

  def show
    @token = Token[:value => params[:token]] unless params[:token] == nil
    @token = Token[:value => params[:id]] unless params[:id] == nil

    if (@token && @token.valid_to_use?)
      message[:notice] = "Witamy w sesji"
    else
      message[:error] = "Nieważny token"
      return redirect url(:controller => "answers", :action => "index"), :message => message
    end

    @question_answers = @token.poll.questions.map { |q| [q, QuestionAnswer.new] }

    render
  end

  def save_answer
    @token = Token[:value => params[:token]]

    if (@token.blank? || !@token.valid_to_use?)
      message[:error] = "Nieważny token"
      return redirect url(:controller => "answers", :action => "index"), :message => message
    end

    @answer = Answer.new(:token => @token, :date => DateTime.now, :poll => @token.poll)
    @question_answers = @token.poll.questions.map do |question|
      value = params[question.id.to_s]
      question_answer = QuestionAnswer.new(:question => question, :value => value)
      @answer.question_answers << question_answer
      [question, question_answer]
    end

    if @answer.valid?
      unless @answer.question_answers.map(&:valid_without_answer?).all?
        raise Sequel::ValidationFailed.new(@answer.question_answers.map(&:errors))
      end
    else
      raise Sequel::ValidationFailed.new(@answer.errors)
    end

    @answer.save
    @question_answers.each do |question, question_answer|
      question_answer.answer = @answer
      question_answer.save
    end
    render
  rescue Sequel::ValidationFailed
    @question_answers.each do |question, question_answer|
      params[question.id] = question_answer.value
    end
    render :show
  end
end

