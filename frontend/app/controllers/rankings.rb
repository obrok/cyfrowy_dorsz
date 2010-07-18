class Rankings < Application
  # provides :xml, :yaml, :js

  def index
    @users = User.all
    render
  end

end

