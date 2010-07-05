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
    poll = create_poll
    token = create_token(:poll => poll)
    question = create_question(:poll => poll)
    fill_in "Token", :with => token.value
    click_button "Wypełnij ankietę"

    fill_in question.text, :with => "3"
    click_button "Wyślij odpowiedzi"
    response.should include "Dziękujemy za wypełnienie ankiety"
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
end
