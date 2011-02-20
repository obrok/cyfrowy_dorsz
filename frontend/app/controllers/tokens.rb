require 'lib/load_helper'

class Tokens < Application
  include LoadHelper

  before :ensure_authenticated
  before :load_poll, :only => [:delete, :index, :generate, :save, :print]
  before :load_token, :only => [:delete]
  def new
    render
  end

  def index
    @tokens = @poll.tokens
    render
  end

  def generate
    @errors = {}
    render
  end

  def save
    @errors = {}
    @errors[:max_usage] = "Niepoprawna wartość" if params[:max_usage].to_i < 1
    @errors[:count] = "Niepoprawna wartość" if params[:count].to_i < 1 and params[:value].blank?
    return render :generate unless @errors.empty?

    valid_until = DateTime.parse(params[:valid_until])
    if (params[:value].blank?)
      params[:count].to_i.times do
        create(valid_until, 1, Token.generate_random_value)
      end
    else
      create(valid_until, params[:max_usage].to_i, params[:value])
    end

    redirect resource(@poll, :tokens)
  rescue Sequel::ValidationFailed
    Token.columns.each { |c| @errors[c] = @token.errors.on(c) }
    render :generate
  end

  def delete
    @token.destroy 
    redirect(resource(@poll, :tokens), :message => message)
  end

  def print
    render :layout => false
  end

  protected

  def create(valid_until, max_usage, value)
    @token = Token.new(:poll => @poll, :valid_until => valid_until, :max_usage => max_usage, :value => value)
    @token.save
  end

end

