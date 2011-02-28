# -*- coding: utf-8 -*-
require 'spec/spec_helper'

describe "Per question results" do
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

  it "should be possible to navigate to a question's answers" do
    click_link "Odpowiedzi do pytania Pytanie 1"
    response.should include "Pytanie 1"
    response.should_not include "Pytanie 2"
  end

  it "should contain the correct answers" do
    click_link "Odpowiedzi do pytania Pytanie 1"
    response.should include "Odpowiedź 1"
    response.should include "Odpowiedź 2"
    response.should_not include "Odpowiedź 3"
  end

  it "should display charts page correctly" do
    click_link "Statystyki"
    response.should include "Statystyki pytań zamkniętych dla ankiety"
    response.should include @poll.name
    response.should include "visualize"
  end

  it "should display teacher question ansewers properly" do
    click_link "Odpowiedzi do pytania Pytanie 3"
    response.should include Question.user_to_teacher(@user)
  end

  it "should filter results per teacher" do
    click_link "Odpowiedzi do pytania Pytanie 1"
    select Question.user_to_teacher(@user), :from => "Pokaż odpowiedzi dla"
    click_button "Pokaż"
    response.should include @a1.value
    response.should_not include @a2.value
  end

  it "should display number of answers in polls list" do
    visit resource(:polls)
    response.should include "Liczba odpowiedzi"
    p @poll.answers.count.to_s
    p @poll2.answers.count.to_s
    response.should include @poll.answers.count.to_s
    response.should include @poll2.answers.count.to_s
  end
end

describe "Per question results from poll without teacher question" do
  before(:each) do
    @poll = create_poll
    @user = @poll.user
    @q1 = create_question(:text => "Pytanie 1", :poll => @poll, :question_type => Question::TYPES[:open])
    @q2 = create_question(:text => "Pytanie 2", :poll => @poll, :question_type => Question::TYPES[:open])

    @a1 = create_question_answer(:question => @q1, :value => "Odpowiedź 1")
    @a2 = create_question_answer(:question => @q1, :value => "Odpowiedź 2")
    @a3 = create_question_answer(:question => @q2, :value => "Odpowiedź 3")

    login_as(@user, CreationTestHelper::USER_HASH[:password])
    visit resource(@poll, :edit)
  end

  it "should be possible to navigate to a question's answers" do
    click_link "Odpowiedzi do pytania Pytanie 1"
    response.should include "Pytanie 1"
    response.should_not include "Pytanie 2"
  end

  it "should contain the correct answers" do
    click_link "Odpowiedzi do pytania Pytanie 1"
    response.should include "Odpowiedź 1"
    response.should include "Odpowiedź 2"
    response.should_not include "Odpowiedź 3"
  end

  it "should display charts page correctly without teacher filter" do
    click_link "Statystyki"
    response.should include "Statystyki pytań zamkniętych dla ankiety"
    response.should include @poll.name
    response.should include "visualize"
    response.should_not include "Pokaż odpowiedzi dla"
  end

  it "should not display teacher filter" do
    click_link "Odpowiedzi do pytania Pytanie 1"
    response.should_not include "Pokaż odpowiedzi dla"
  end

  it "should inform about filtering possiblity" do
    click_link "Odpowiedzi do pytania Pytanie 1"
    response.should include "Możesz dodać pytanie o prowadzącego aby filtrować wyniki."
  end

  it "should inform about filtering possiblity on charts page" do
    click_link "Statystyki"
    response.should include "Możesz dodać pytanie o prowadzącego aby filtrować wyniki."
  end
end
