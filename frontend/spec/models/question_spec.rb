require 'spec/spec_helper'

describe Question do
  before(:each) do
    @question = create_question
  end

  after(:each) do
    @question.destroy
  end

  it "should be valid" do
    @question.should be_valid
  end

  [:text, :poll, :question_type].each do |field|
    it "should validate presence of #{field}" do
      @question.send("#{field}=", nil)
      @question.should_not be_valid
    end
  end

  it "should have valid question type" do
    @question.question_type = "invalid_type"
    @question.should_not be_valid
  end

  it "should allow access to answers" do
    answer = create_question_answer(:question => @question)
    @question.reload.question_answers.should include answer
  end

  it "should convert teacher's id's to ints" do
    question = create_question(:question_type => Question::TYPES[:teacher])
    question.add_possible_answer("123")
    question.possible_answers.should include 123
  end

  it "should automatically convert stored user ids to user info in teacher choice question" do
    user = create_user
    question = create_question(:question_type => Question::TYPES[:teacher])
    user_info = Question.user_to_teacher(user)

    question.add_possible_answer(user.id)

    question.formatted_possible_answers.should include user_info
  end
  it "should not be valid if there is another questions with the same name in parent poll" do
    question = new_question(:poll => @question.poll, :text => @question.text)
    question.should_not be_valid
  end
end

describe "Closed Question" do
  before(:each) do
    @question = create_question(:question_type => "Wyboru")
  end

  after(:each) do
    @question.destroy
  end

  it "should be valid" do
    @question.should be_valid
  end

  it "should be choice" do
    @question.should be_choice
    @question.should_not be_open
    @question.should_not be_closed
  end

  it "should have no possible answers by default" do
    @question.possible_answers.class.should == Array
    @question.possible_answers.should_not be_empty
  end

  it "should properly serialize an array of strings" do
    @question.possible_answers = ["Tak", "Nie"]
    @question.save
    @question.reload
    
    @question.possible_answers.class.should == Array
    @question.possible_answers.should include "Tak"
    @question.possible_answers.should include "Nie"
  end
end
