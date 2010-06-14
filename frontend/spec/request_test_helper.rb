require 'lib/csrf'

module RequestTestHelper
  def csrf_params
    token, timestamp = generate_token
    {"_csrf_token" => token, "_csrf_timestamp" => timestamp}
  end
end

include CSRF
include RequestTestHelper
