require 'lib/csrf'

class Application < Merb::Controller
  include CSRF
  before :ensure_csrf_valid

  protected

  def ensure_anonymous
    raise Forbidden if session.user
  end

  def ensure_csrf_valid
    if [:put, :post].include?(request.method)        
      raise BadRequest unless token_valid?
    end
  end
end
