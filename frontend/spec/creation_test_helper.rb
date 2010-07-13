# -*- coding: utf-8 -*-
module CreationTestHelper
  USER_HASH = {
    :email => "example@example.com",
    :password => "123",
    :password_confirmation => "123",
  }

  POLL_HASH = {    
  }

  QUESTION_HASH = {
    :text => "tresc pytania", 
    :question_type => "Zamknięte",
  }

  ANSWER_HASH = {
  }

  QUESTION_ANSWER_HASH = {
    :value => 3
  }

  TOKEN_HASH = {
    :max_usage => 1
  }

  def user_hash
    USER_HASH.merge(:email => "#{Time.now.to_f}@example.com")
  end

  def poll_hash
    POLL_HASH.merge(:name => "#{Time.now.to_f}", :poll_type => Poll::TYPES[rand(Poll::TYPES.size)], :user => create_user)
  end

  def answer_hash
    poll = create_poll
    ANSWER_HASH.merge(:date => DateTime.now, :poll => poll, :token => create_token(:poll => poll))
  end

  def question_hash
    QUESTION_HASH.merge(:poll => create_poll)
  end

  def question_answer_hash
    question = create_question
    QUESTION_ANSWER_HASH.merge(:question => question, :answer => create_answer(:poll => question.poll))
  end

  def token_hash
    TOKEN_HASH.merge(:poll => create_poll, :value => Token.generate_random_value, :valid_until => Time.now + 1.day, :max_usage => 7)
  end

  def create_user(values = {})
    User.create(user_hash.merge(values))
  end

  def create_poll(values = {})
    Poll.create(poll_hash.merge(values))
  end

  def create_question(values = {})
    Question.create(question_hash.merge(values))
  end
                
  def create_answer(values = {})
    Answer.create(answer_hash.merge(values))
  end

  def create_question_answer(values = {})
    QuestionAnswer.create(question_answer_hash.merge(values))
  end

  def create_token(values = {})
    Token.create(token_hash.merge(values))
  end
end

include CreationTestHelper
