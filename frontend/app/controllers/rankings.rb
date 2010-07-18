class Rankings < Application
  layout :anonymous

  def index
    rankings = Hash.new

    User.all.each do |user|
      rankings[user] = user.ranking == "-" ? -1 : user.ranking
    end

    @users = User.all.sort_by{|u| rankings[u] }.reverse
    render
  end

end

