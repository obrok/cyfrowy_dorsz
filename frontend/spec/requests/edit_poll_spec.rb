# -*- coding: utf-8 -*-
require 'spec/spec_helper'

describe Questions, "Creating the poll" do
  before(:each) do
    @user = create_user
    @poll = create_poll(:user => @user)
    login_as(@user, CreationTestHelper::USER_HASH[:password])
    visit(resource(@poll, :edit))
  end

  after(:each) do
    logout
  end

  it "is possible to change thankyou text" do
    fill_in("Tekst podziękowania", :with => "Nowy tekst podziękowania")
    click_button("Zmień")
    @poll.reload.thankyou.should == "Nowy tekst podziękowania"
  end
end

describe "Poll with answers" do
  before(:each) do
    @poll = create_poll
    @poll2 = create_poll(:user => @poll.user)
    @user = @poll.user
    @user2 = create_user
    @q1 = create_question(:text => "Pytanie 1", :poll => @poll, :question_type => Question::TYPES[:open])
    @q2 = create_question(:text => "Pytanie 2", :poll => @poll, :question_type => Question::TYPES[:open])
    @q3 = create_question(:text => "Pytanie 3", :poll => @poll, :question_type => Question::TYPES[:teacher])
    @q3.add_possible_answer(@user.id)
    @q3.add_possible_answer(@user2.id)
    @q3.save

    @a1 = create_question_answer(:question => @q1, :value => "Odpowiedź 1")
    @a2 = create_question_answer(:question => @q1, :value => "Odpowiedź 2")
    @a3 = create_question_answer(:question => @q2, :value => "Odpowiedź 3")
    @a4 = create_question_answer(:question => @q3, :value => @user.id, :answer => @a1.answer)
    @a5 = create_question_answer(:question => @q3, :value => @user2.id, :answer => @a2.answer)    

    login_as(@user, CreationTestHelper::USER_HASH[:password])
    visit resource(@poll, :edit)
  end

  it "should not be possible to add questions" do
    response.should_not include "Dodaj nowe pytanie"
  end

  it "should not be possible to edit questions" do
    response.should include "Edycja jest niemożliwa."
  end

  it "should not be possible to delete questions" do
    response.should include "Nie można usunąć pytania."
  end

  it "should not be possible to change thankyou text" do
    response.should_not include "Zmień"
  end
end

