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

  def create_answer(poll = nil)
    poll = create_poll unless poll
    Answer.create(:date => DateTime.now, :poll => poll)
  end

  def create_question_answer
    question = create_question
    QuestionAnswer.create(:question => question, :answer => create_answer(question.poll), :value=>"3")
  end

  def create_question(poll = nil)
    poll = create_poll unless poll
    Question.create(
      :poll => poll, 
      :text => "tresc pytania", 
      :question_type => Question::TYPES[rand(Question::TYPES.size)]
    )
  end

  def create_token(poll = nil)
    poll = create_poll unless poll

    token = Token.new
    token.used = false
    token.value = Token.generate_random_value
    token.poll = poll
    token.valid_until = DateTime.now + 1

    token.save
    return token
  end
end

include CreationTestHelper
