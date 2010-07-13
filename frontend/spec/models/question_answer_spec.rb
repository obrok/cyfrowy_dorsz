# -*- coding: utf-8 -*-
require 'spec/spec_helper'

describe QuestionAnswer do
  before(:each) do
    @answer = create_question_answer
  end

  after(:each) do
    @answer.destroy
  end

  it "should be valid" do
    @answer.should be_valid
  end

  [:value, :question, :answer].each do |field|
    it "should validate presence of #{field}" do
      @answer.send("#{field}=", nil)
      @answer.should_not be_valid
    end
  end

  it "should validate the answer to a choice question" do
    question = create_question(:question_type => "Wyboru")
    question.possible_answers = ["Odpowiedź1", "Odpowiedź2"]
    @answer.question = question
    @answer.answer = create_answer(:poll => question.poll)

    @answer.value = "Odpowiedź3"
    @answer.should_not be_valid
    @answer.value = "Odpowiedź2"
    @answer.should be_valid
  end
end
