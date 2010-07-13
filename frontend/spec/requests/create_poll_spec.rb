# -*- coding: utf-8 -*-
require 'spec/spec_helper'

describe Questions, "Creating the poll" do
  before(:each) do
    @user = create_user
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
    @poll = create_poll
    visit resource(@poll, :edit)
    response.should include "Dodaj nowe pytanie"
  end

  it "shows edit question form correctly" do
    poll = create_poll(:user => @user)
    question = create_question(:poll => poll)
    visit resource(poll, question, :edit)
    response.should include question.text
  end

  it "adds new question correctly" do
    poll = create_poll(:user => @user)
    visit resource(poll, :edit)
    question = create_question
    fill_in "Treść pytania", :with => question.text
    fill_in "Typ pytania", :with => question.question_type
    click_button "Zapisz pytanie"

    response.should include(question.text)
  end

  it "shows all current answers to a choice question" do
    poll = create_poll(:user => @user)
    question = create_question(:poll => poll, :question_type => "Wyboru", :possible_answers => ["Odpowiedź1", "Odpowiedź2"])
    visit resource(poll, :edit)
    
    question.possible_answers.each do |answer|
      response.should include answer
    end
  end

  it "allows to add an answer to a choice question" do
    pending
  end

  it "allows to remove an answer from a choice question" do
    pending
  end
end
