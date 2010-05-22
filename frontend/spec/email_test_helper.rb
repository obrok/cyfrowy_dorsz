module EmailTestHelper
  def last_email
    Merb::Mailer.deliveries.last
  end
end

include EmailTestHelper
