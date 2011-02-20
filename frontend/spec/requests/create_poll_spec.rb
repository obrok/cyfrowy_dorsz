# -*- coding: utf-8 -*-
require 'spec/spec_helper'

describe Questions, "Creating the poll" do
  before(:each) do
    @user = create_user
    @poll = create_poll(:user => @user)
    login_as(@user, CreationTestHelper::USER_HASH[:password])
  end

  after(:each) do
    logout
  end

  it "shows new poll form" do
    visit resource(:polls, :new)
    response.should include "Podaj nazwę nowej ankiety"
  end

  it "creates the poll correctly" do
    poll = create_poll
    visit resource(:polls, :new)
    fill_in "Nazwa", :with => poll.name
    fill_in "Typ zajęć", :with => poll.poll_type
    click_button "Stwórz"
    response.should include "Stworzono ankietę " + poll.name
  end

  it "shows edit poll form correctly" do
    visit resource(@poll, :edit)
    response.should include "Dodaj nowe pytanie"
  end

  it "shows edit question form correctly" do
    question = create_question(:poll => @poll)
    visit resource(@poll, question, :edit)
    response.should include question.text
  end

  it "adds new question correctly" do
    visit resource(@poll, :edit)
    question = create_question
    fill_in "Treść pytania", :with => question.text
    fill_in "Typ pytania", :with => question.question_type
    click_button "Zapisz pytanie"

    response.should include(question.text)
  end

  it "shows all current answers to a choice question" do
    question = create_question(:poll => @poll, :question_type => "Wyboru", :possible_answers => ["Odpowiedź1", "Odpowiedź2"])
    visit resource(@poll, question, :edit)
    
    question.possible_answers.each do |answer|
      response.should include answer
    end
  end

  it "allows to add an answer to a choice question" do
    question = create_question(:poll => @poll, :question_type => "Wyboru", :possible_answers => ["Odpowiedź1", "Odpowiedź2"])
    visit resource(@poll, question, :edit)

    fill_in "Nowa odpowiedź", :with => "Odpowiedź3"
    click_button "Dodaj odpowiedź"

    question.reload.possible_answers.should include "Odpowiedź3"
  end

  it "allows to remove an answer from a choice question" do
    question = create_question(:poll => @poll, :question_type => "Wyboru", :possible_answers => ["Odpowiedź1", "Odpowiedź2"])
    visit resource(@poll, question, :edit)
    
    click_link "Usuń Odpowiedź1"

    question.reload.possible_answers.should_not include "Odpowiedź1"
  end

  it "shows user info as possible answer in teacher choice question" do
    visit resource(@poll, :edit)
    fill_in "Treść pytania", :with => "Jaki prowadzący?"
    fill_in "Typ pytania", :with => "Prowadzący"
    click_button "Zapisz pytanie"
    click_link "Edytuj Jaki prowadzący?"

    response.should include Question.user_to_teacher(@user)
  end

  it "allows to add teacher choice question only once" do
    visit resource(@poll, :edit)
    fill_in "Treść pytania", :with => "Jaki prowadzący?"
    fill_in "Typ pytania", :with => "Prowadzący"
    click_button "Zapisz pytanie"

    visit resource(@poll, :edit)
    lambda{select "Prowadzący", :from => "Typ pytania"}.should raise_error
  end

  it "shows error message if poll already contains a question with given name" do
    question = create_question

    visit resource(@poll, :edit)
    fill_in "Treść pytania", :with => question.text
    fill_in "Typ pytania", :with => question.question_type
    click_button "Zapisz pytanie"

    visit resource(@poll, :edit)
    fill_in "Treść pytania", :with => question.text
    fill_in "Typ pytania", :with => question.question_type
    click_button "Zapisz pytanie"

    response.should include "Pytanie o takiej nazwie już istnieje"
  end

  it "should be forbidden to edit someones else poll" do
    poll = create_poll
    visit resource(poll, :edit)

    response_status.should == 404
  end
end
