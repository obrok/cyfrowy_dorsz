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

  def create_question(values = {})
    Question.create(
      :poll => create_poll, 
      :text => "tresc pytania", 
      :question_type => Question::TYPES[rand(Question::TYPES.size)]
    )
  end
end

include CreationTestHelper
