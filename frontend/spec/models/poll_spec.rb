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
 
  it "should not be blocked after creation" do
    @poll.blocked?.should be_false
  end

  it "should allow copying" do
    q1 = create_question(:question_type => Question::TYPES[:teacher], :poll => @poll)
    u1 = create_user
    q1.add_possible_answer(u1.id)

    q2 = create_question(:question_type => Question::TYPES[:closed], :poll => @poll)
    
    other = @poll.copy!

    other.id.should_not == @poll.id
    other.user.should == @poll.user
    other.thankyou.should == @poll.thankyou
    other.copy_of.should == @poll
    other.name.should == @poll.name + " Kopia"

    q1copy = other.questions.find{|x| x.text == q1.text}
    q1copy.should_not be_nil
    q1copy.id.should_not == q1.id
    q1copy.possible_answers.should == q1.reload.possible_answers
    q1copy.copy_of.id.should == q1.id

    other.questions.find{|x| x.text == q2.text}.should be_true
  end

  it "should be only possible to have one main poll" do
    main = create_poll(:main => true)
    @poll.make_main!
    main.reload.should_not be_main
    @poll.should be_main
  end

  it "should make main's copy not main" do
    main = create_poll(:main => true)
    main.copy!.should_not be_main
  end
end
