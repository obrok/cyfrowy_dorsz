class Application < Merb::Controller
  protected
  def ensure_anonymous
    raise Forbidden if session.user
  end
end
