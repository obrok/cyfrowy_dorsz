class BaseMailer < Merb::MailController
  protected
  def resource(*args)
    "http://" + Merb::Config[:hostname] + super(*args)
  end

  def url(*args)
    "http://" + Merb::Config[:hostname] + super(*args)
  end
end
