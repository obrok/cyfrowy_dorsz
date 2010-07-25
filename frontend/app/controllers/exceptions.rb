require 'lib/csrf'

class Exceptions < Merb::Controller
  include CSRF
  layout :anonymous
  
  # handle NotFound exceptions (404)
  def not_found
    render :format => :html
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    render :format => :html
  end

  # handle Forbidden exceptions (403)
  def forbidden
    render :format => :html
  end

end
