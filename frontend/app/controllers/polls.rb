# -*- coding: utf-8 -*-
require 'lib/load_helper'

class Polls < Application
  include LoadHelper  
  before :ensure_authenticated
  before :ensure_not_blocked
  before :load_poll, :only => [:edit, :stats, :update]
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
    @poll = Poll.new(poll)
    @poll.blocked = false
    @poll.visible = true
    @poll.save
    redirect resource(@poll, :edit), :notice => "Stworzono ankietę #{h(@poll.name)}"
  rescue Sequel::ValidationFailed
    @polls = session.user.reload.polls
    render :new
  end
  
  def edit
    @question = Question.new(:poll => @poll, :question_type => Question::TYPES[:choice])
    @questions = @poll.questions_dataset.order(:position)
    @question_types = @poll.load_question_types
    
    render
  end

  def update
    @poll.update_only(params[:poll], :thankyou, :name)
    redirect(resource(@poll, :edit), :notice => "Tekst podziękowania zmieniony")
  rescue Exception
    redirect(resource(@poll, :edit), :error => "Tekst podziękowania nie może być pusty")
  end

  def stats
    user = User[:id => params[:teacher_id]]
    @questions = @poll.questions_dataset.filter(:question_type => Question::TYPES[:closed]).all
    @answers = @poll.setup_answers_for_stats(@questions, user)
    @teachers = (@poll.teacher_question &&  @poll.teacher_question.selectable_possible_answers) || []

    render
  end

  def show
    change_visibility(true)
  end

  def hide
    change_visibility(false)
  end

  def block
    change_blocked(true)
  end

  def unblock
    change_blocked(false)
  end

  private

  def change_blocked(blocked)
    user = session.user
    @poll = Poll[:id => params[:id]]
    if user.admin? then
      @poll.blocked = blocked
      @poll.save
    else 
      raise Forbidden
    end
    
    if session.user.admin?
      redirect(resource(:users, :admin))
    else
      redirect(resource(@poll, :edit))
    end
  end

  def change_visibility(visible)
    user = session.user
    @poll = Poll[:id => params[:id]]
    if user.id == @poll.user.id then
      @poll.visible = visible
      @poll.save
    end
    
    redirect(resource(@poll, :edit))
  end
end

