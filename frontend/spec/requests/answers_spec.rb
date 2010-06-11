require 'spec/spec_helper'

describe "Student" do
  before(:each) do
    visit "/answers"
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

  it "should save after stadent's submission" do
    poll = create_poll
    token = create_token(poll)
    question = create_question(poll)

    fill_in "Token", :with => token.value
    click_button "Wypełnij ankietę"

    fill_in question.text, :with => "3"
    click_button "Wyślij odpowiedzi"
    response.should include "Dziękujemy za wypełnienie ankiety"

    token = Token[token.id]
    token.used.should equal true
    poll = Poll[poll.id]
    poll.answers.size.should equal 1
  end
end
