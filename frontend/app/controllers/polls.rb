# -*- coding: utf-8 -*-
class Polls < Application
  before :ensure_authenticated
  before :load_poll, :only => [:edit, :stats]

  # provides :xml, :yaml, :js

  # GET /polls/new
  def new
    @polls = session.user.polls
    @poll = Poll.new
    render
  end

  def index
    @polls = session.user.polls
    render
  end

  # POST /polls
  def create
    @poll = Poll.new(params[:poll] || {})
    begin
      @poll.user = session.user
      @poll.save
      redirect(resource(@poll, :edit), :notice => "Stworzono ankietę " + @poll.name)
    rescue Sequel::ValidationFailed
      render :new
    end
  end

  def edit    
    @action = resource(@poll, :questions)
    @method = :post
    @question = Question.new(:poll => @poll)
    @questions = @poll.questions_dataset.order(:position)

    if !@poll.contains_teacher_question
      @question_types = Question::TYPES.values
    else 
      @question_types = Array.new(Question::TYPES.values)
      @question_types.delete(Question::TYPES[:teacher])
    end

    render
  end

  def stats
    user = User[params[:teacher_id]]
    @questions = @poll.questions_dataset.filter(:question_type => Question::TYPES[:closed])
    @answers = []
    @questions.each_with_index do |question, i|
      collection = user ? question.question_answers_for_user(user) : question.question_answers
      collection.each_with_index do |answer, j|
        unless @answers[j]
          @answers[j] = []
        end
        @answers[j][i] = answer
      end
    end
    @teachers = (@poll.teacher_question &&  @poll.teacher_question.selectable_possible_answers) || []

    render
  end



  protected

  def load_poll
    @poll = Poll[:id => params[:id]] or raise NotFound unless @poll
  end

end

