class Tokens < Application
  before :ensure_authenticated
  before :load_poll, :only => [:index, :generate, :save, :print]

  # provides :xml, :yaml, :js

  # GET /questions/new
  def new
    @token = Token.new
    render
  end

  def index
    @tokens = @poll.tokens
    render
  end

  def create(valid_until, token_type, max_usage, value)
    date = DateTime.parse(valid_until)

    token = Token.new
    token.poll = @poll
    token.valid_until = date
    token.max_usage = max_usage
    token.value = value
    begin
      token.save

      redirect(resource(@poll, :edit))
    rescue Sequel::ValidationFailed
      render :generate
    end
  end

  def generate
    render
  end

  def save
    params[:count].to_i.times do
      value = params[:value].blank? ? Token.generate_random_value : params[:value]
      create(params[:valid_until], params[:token_type], params[:max_usage].to_i, value)
    end

    redirect(url(:poll_tokens, @poll))
  end

  def delete(id)
    @token = Token[:id =>id]    
    poll = @token.poll

    raise NotFound unless @token
    if @token.destroy
      redirect resource(poll, :tokens)
    else
      raise InternalServerError
    end
  end

  def print
    render :layout => false
  end

  protected

  def load_poll
    @poll = Poll[params[:poll_id]]
  end
end

