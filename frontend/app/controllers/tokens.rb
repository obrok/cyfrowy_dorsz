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

  def create(valid_until, max_usage, value)
    date = DateTime.parse(valid_until)
    @token = Token.create(:poll => @poll, :valid_until => date, :max_usage => max_usage, :value => value)
  rescue Sequel::ValidationFailed
    render :generate
  end

  def generate
    render
  end

  def save
    count = params[:count].blank? ? 1 : params[:count].to_i

    count.times do
      value = params[:value].blank? ? Token.generate_random_value : params[:value]       
      create(params[:valid_until], params[:max_usage].to_i, value)
    end

    redirect(url(:poll_tokens, @poll))
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
end

