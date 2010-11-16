# -*- coding: utf-8 -*-
class Answers < Application
  layout :anonymous
  
  def index
    render
  end

  def show
    @token = Token[:value => params[:token]] unless params[:token] == nil
    @token = Token[:value => params[:id]] unless params[:id] == nil

    if (@token.present? && @token.valid_to_use?)
      message[:notice] = "Witamy w sesji"
    else
      message[:error] = "Nieważny token"
      return redirect url(:controller => "answers", :action => "index"), :message => message
    end

    render
  end

  def save_answer
    @token = Token[:value => params[:token]]

    if (@token.blank? || !@token.valid_to_use?)
      message[:error] = "Nieważny token"
      return redirect url(:controller => "answers", :action => "index")
    end

    @answer = Answer.create(:token => @token, :date => DateTime.now, :poll => @token.poll)
    @qestion_answers = @token.poll.questions.map do |question|
      value = params[question.id.to_s]
      QuestionAnswer.create(:question => question, :value => value, :answer => @answer)
    end

    render
  rescue Sequel::ValidationFailed
    render :show
  end
end

