module CreationTestHelper
  USER_HASH = {
    :email => "example@example.com",
    :password => "123",
    :password_confirmation => "123",
  }

  def user_hash
    USER_HASH.merge(:email => "#{Time.now.to_f}@example.com")
  end

  def create_user(values = {})
    User.create(user_hash.merge(values))
  end
end

include CreationTestHelper
