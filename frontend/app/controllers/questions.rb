require 'lib/load_helper'

class Questions < Application
  include LoadHelper

  before :ensure_authenticated
  before :ensure_not_blocked
  before :load_poll, :exclude => [:new]
  before :load_question, :exclude => [:new, :create, :update_positions]
  before :ensure_can_manage, :exclude => [:new, :create, :update_positions]

  def new
    @question = Question.new
    render
  end

  def create
    question = params[:question].merge(:position => params[:position], :poll => @poll) || {}
    @question = Question.new(question)
    @question_types = Question::TYPES.values
    @question.save
    render partial('question', :question => @question, :poll => @poll), :layout => false
  rescue Sequel::ValidationFailed
    render partial('new', :question => @question, :poll => @poll), :layout => false, :status => 409
  end

  def edit
    @question_types = @question.load_question_types
    render
  end

  def update
    @question.update(params[:question])
    redirect resource(@poll, :edit)
  rescue Sequel::ValidationFailed
    @question_types = @question.load_question_types
    render :edit
  end

  def update_positions
    positions = params[:positions] or return
    @poll.update_questions_positions(positions)
    ""
  end

  def delete
    @question.destroy
    redirect resource(@poll, :edit)
  end

  protected

  def load_question
    @question = @poll.questions_dataset.filter(:id => params[:id]).first or raise NotFound
  end

  def ensure_can_manage
    raise Forbidden if @question.locked?
  end
end

