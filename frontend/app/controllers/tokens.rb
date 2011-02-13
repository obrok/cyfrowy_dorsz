class Tokens < Application

  before :ensure_authenticated
  before :load_poll, :only => [:index, :generate, :save, :print]

  def new
    @token = Token.new
    render
  end

  def index
    @tokens = @poll.tokens
    render
  end

  def generate
    render
  end

  def save
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
    render :generate
  end

  def delete(id)
    @token = Token[:id =>id]    
    poll = @token.poll

    @token.destroy
    redirect resource(poll, :tokens)
  end

  def print
    render :layout => false
  end

  protected

  def load_poll
    @poll = Poll[params[:poll_id]]
  end

  def create(valid_until, max_usage, value)
    @token = Token.new(:poll => @poll, :valid_until => valid_until, :max_usage => max_usage, :value => value)
    @token.save
  end

end

