class Tokens < Application
  before :ensure_authenticated

  # provides :xml, :yaml, :js

  # GET /questions/new
  def new
    @token = Token.new
    render
  end

  def index
    @poll = Poll[params[:poll_id]]
    @tokens = @poll.tokens
    render
  end

  def create(valid_until)
    date = DateTime.parse(valid_until)

    token = Token.new
    token.poll = @poll
    token.valid_until = date
    token.value = Token.generate_random_value
    token.used = false
    begin
      token.save

      redirect(resource(@poll, :edit))
    rescue Sequel::ValidationFailed
      render :generate
    end
  end

  def generate
    @tokeninfo
    @poll = Poll[params[:id]]
    render
  end

  def save
    @poll = Poll[params[:id]]

    params[:count].to_i.times do
      create(params[:valid_until])
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
end

