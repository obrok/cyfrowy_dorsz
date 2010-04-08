class Secured < Application
  before(:ensure_user_logged_in)

  private
  def ensure_user_logged_in
    raise Unauthenticated unless session.user
  end
end
