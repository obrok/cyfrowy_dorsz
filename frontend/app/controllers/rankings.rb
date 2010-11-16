class Rankings < Application
  layout :anonymous

  def index
    @users = User.all_by_rankings
    render
  end

end

