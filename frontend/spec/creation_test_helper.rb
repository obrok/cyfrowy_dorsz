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

  def create_poll(values = {})
    Poll.create(:name => "#{Time.now.to_f}")
  end

  def create_user_poll(user, name)
    Poll.create(:user => user, :name => name)
  end

  def create_question(values = {})
    Question.create(
      :poll => create_poll, 
      :text => "tresc pytania", 
      :question_type => Question::TYPES[rand(Question::TYPES.size)]
    )
  end

  def create_token
    token = Token.new
    token.value = Token.generate_random_value
    token.poll = create_poll
    token.valid_until = DateTime.now + 1

    token.save
    return token
  end
end

include CreationTestHelper
