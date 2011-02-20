# -*- coding: utf-8 -*-
class Polls < Application
  
  before :ensure_authenticated
  before :load_poll, :only => [:edit, :stats]
  before :load_polls, :only => [:new, :index, :create]

  def new
    @poll = Poll.new
    render
  end

  def index
    render
  end

  def create
    poll = (params[:poll] || {}).merge(:user => session.user)
    @poll = Poll.create(poll)
    redirect resource(@poll, :edit), :notice => "Stworzono ankietę #{@poll.name}"
  rescue Sequel::ValidationFailed
    @polls = session.user.reload.polls
    render :new
  end

  def edit
    @question = Question.new(:poll => @poll)
    @questions = @poll.questions_dataset.order(:position)
    @question_types = @poll.load_question_types
    
    render
  end

  def stats
    user = User[:id => params[:teacher_id]]
    @questions = @poll.questions_dataset.filter(:question_type => Question::TYPES[:closed]).all
    @answers = @poll.setup_answers_for_stats(@questions, user)
    @teachers = (@poll.teacher_question &&  @poll.teacher_question.selectable_possible_answers) || []

    render
  end

  protected

  def load_poll
    @poll = session.user.polls_dataset[:id => params[:id]] or raise NotFound unless @poll
  end

  def load_polls
    @polls = session.user.polls
  end

end

