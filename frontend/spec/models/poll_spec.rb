# -*- coding: utf-8 -*-
require 'spec/spec_helper'

describe Poll do
  before(:each) do
    @poll = create_poll
  end

  after(:each) do
    @poll.destroy
  end

  it "should be valid" do
    @poll.should be_valid
  end

  it "should have a default thankyou text" do
    Poll.new.thankyou.should == "Dziękujemy za wypełnienie ankiety"
  end

  it "should validate presence of thankyou text" do
    @poll.thankyou = ""
    @poll.should_not be_valid
  end

  it "should validate presence of name" do
    @poll.name = nil
    @poll.should_not be_valid
  end

  it "should validate poll type" do
    @poll.poll_type = 'something stupid'
    @poll.should_not be_valid
  end

  it "should update questions' positions properly" do
    questions = (1..3).map { |i| create_question(:poll => @poll, :position => i) }
    positions = {
      questions[2].id.to_s => '1',
      questions[0].id.to_s => '3'
    }
    @poll.update_questions_positions(positions)
    sorted_questions = @poll.questions_dataset.order(:position).map(&:id)
    sorted_questions.should == [questions[2].id, questions[1].id, questions[0].id]
  end


  it "should filter answers per user" do
    q1 = create_question(:question_type => Question::TYPES[:teacher], :poll => @poll)
    u1 = create_user
    u2 = create_user

    q1.add_possible_answer(u1.id)
    q1.add_possible_answer(u2.id)
    q1.save

    a1 = create_question_answer(:question => q1, :value => u1.id)
    a2 = create_question_answer(:question => q1, :value => u2.id)

    @poll.reload.answers_for_user(u1).should include a1.answer
    @poll.answers_for_user(u1).should_not include a2.answer
  end
 
end
