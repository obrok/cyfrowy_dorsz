# -*- coding: utf-8 -*-
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
    else
      message[:error] = "Nieważny token"
      return redirect url(:controller => "answers", :action => "index"), :message => message
    end

    render
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
      qas << question.create_question_answer(params[question.id.to_s])
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

