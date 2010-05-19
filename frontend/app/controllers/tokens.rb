class Tokens < Application
  before :ensure_authenticated

  # provides :xml, :yaml, :js

  # GET /questions/new
  def new
    @token = Token.new
    render
  end

  def generate_random_value(size = 8)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K L M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end


  def index
    @tokens = Poll[params[:poll_id]].tokens
    render
  end

  def create(valid_until)
    date = DateTime.parse(valid_until)



    token = Token.new
    token.poll = @poll
    token.valid_until = date
    token.value = generate_random_value
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
    render :generate
  end

  def save
    @poll = Poll[params[:id]]

    params[:count].to_i.times do |i|
      create(params[:valid_until])
    end
  end
end

