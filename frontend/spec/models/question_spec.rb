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
    @question.possible_answers.should be_empty
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
