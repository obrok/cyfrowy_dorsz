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
    @tokens = @poll.tokens_dataset.filter(:token_type=>Token::TYPES[:single])
    @tokens_multi = @poll.tokens_dataset.filter(:token_type=>Token::TYPES[:multi])
    render
  end

  def create(valid_until, token_type, max_usage, value)
    date = DateTime.parse(valid_until)

    token = Token.new
    token.poll = @poll
    token.valid_until = date
    token.max_usage = max_usage
    token.token_type = token_type
    token.value = value
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

  def generate_multi
    @tokeninfo
    @poll = Poll[params[:id]]
    render
  end

  def save
    @poll = Poll[params[:id]]

    if params[:token_type] == Token::TYPES[:multi] then
      create(params[:valid_until], params[:token_type], params[:max_usage], params[:value])
    else  
      params[:count].to_i.times do
        create(params[:valid_until], params[:token_type], 1, Token.generate_random_value)
      end
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

