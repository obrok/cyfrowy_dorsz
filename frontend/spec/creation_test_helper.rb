module CreationTestHelper
  USER_HASH = {
    :email => "example@example.com",
    :password => "123",
    :password_confirmation => "123",
  }

  def user_hash
    USER_HASH
  end

  def create_user
    User.create(user_hash)
  end
end

include CreationTestHelper
