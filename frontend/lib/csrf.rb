require 'digest/sha1'

module CSRF
  SALT = "6c08d7c5de74aeb12ad0a0a4a3a5f47613633f3b"

  def generate_token
    timestamp = Time.now.to_f.to_s
    key = session.user.email if session.user
    token = Digest::SHA1.hexdigest(SALT + timestamp + key.to_s)
    [token, timestamp]
  end

  def token_valid?
    return true if Merb::Config[:disable_csrf]
    key = session.user.email if session.user
    correct = Digest::SHA1.hexdigest(SALT + params["_csrf_timestamp"].to_s + key.to_s)
    params["_csrf_token"] == correct
  end
end
