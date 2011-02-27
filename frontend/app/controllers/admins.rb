class Admins < Application
  before :ensure_admin

  def tasks
    render
  end

  private
  def ensure_admin
    ensure_authenticated
    raise Merb::ControllerExceptions::Forbidden unless session.user.admin? 
  end
end

