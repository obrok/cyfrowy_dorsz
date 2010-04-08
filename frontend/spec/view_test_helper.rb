module ViewTestHelper
  def response
    webrat_session.response_body
  end

  def response_status
    webrat_session.response.status
  end
end

include ViewTestHelper
