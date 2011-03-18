# -*- coding: utf-8 -*-
require 'spec/spec_helper'

describe "Student" do
  before(:each) do
    visit "/"
    click_link "Student"
  end

  it "can access the answers controller" do
    response_status.should == 200
  end

  it "should have to provide correct token to authenticate" do
    token = create_token
    fill_in "Token", :with => token.value
    click_button "Wypełnij ankietę"
    response.should include token.poll.name
  end

  it "should not be authenticated if token is invalid" do
    fill_in "Token", :with => "losowyciag"
    click_button "Wypełnij ankietę"
    response.should include "Nieważny token"
  end

  it "can see poll type when filling in poll" do
    poll = create_poll
    token = create_token(:poll => poll)
    question = create_question(:poll => poll)
    fill_in "Token", :with => token.value
    click_button "Wypełnij ankietę"

    response.should include(poll.poll_type)
  end

  it "should save after student's submission" do
    poll = create_poll(:thankyou => "Dziękujemy bardzo")
    token = create_token(:poll => poll)
    question = create_question(:poll => poll)
    fill_in "Token", :with => token.value
    click_button "Wypełnij ankietę"

    fill_in question.text, :with => "3"
    click_button "Wyślij odpowiedzi"
    response.should include "Dziękujemy bardzo"
  end

  it "should see his answers if something is wrong" do
    poll = create_poll
    token = create_token(:poll => poll)
    question = create_question(:poll => poll, :question_type => "Otwarte", :text => "Pytanie A")
    question2 = create_question(:poll => poll, :question_type => "Otwarte", :text => "Pytanie B")

    fill_in("Token", :with => token.value)
    click_button("Wypełnij ankietę")

    fill_in(question2.text, :with => "Odpowiedź")
    click_button("Wyślij odpowiedzi")
    response.should include "Odpowiedź"
  end

  it "should be able to answer a choice question" do    
    poll = create_poll
    token = create_token(:poll => poll)
    question = create_question(:poll => poll, :question_type => "Wyboru", :text => "Pytanie A", :possible_answers => ["Tak", "Nie"])

    fill_in("Token", :with => token.value)
    click_button("Wypełnij ankietę")

    select "Tak", :from => "Pytanie A"
    click_button("Wyślij odpowiedzi")
    response.should include "Dziękujemy za wypełnienie ankiety"
  end

  it "should properly display teacher question" do
    poll = create_poll
    user = create_user
    question = create_question(:poll => poll, :question_type => Question::TYPES[:teacher], :text => "Prowadzacy")
    question.add_possible_answer(user.id)
    question.save
    token = create_token(:poll => poll)
    
    fill_in("Token", :with => token.value)
    click_button("Wypełnij ankietę")

    select Question.user_to_teacher(user), :from => "Prowadzacy"
    click_button("Wyślij odpowiedzi")

    poll.answers.first.question_answers.first.value.should == user.id.to_s
  end

  it "should not allow to see a hidden poll" do
    token = create_token
    token.poll.visible = false
    token.poll.save

    fill_in "Token", :with => token.value
    click_button "Wypełnij ankietę"
    response.should include "Nieważny token"
  end
end
