require 'spec/spec_helper'

describe "Per question results" do
  before(:each) do
    @poll = create_poll
    @user = @poll.user
    @q1 = create_question(:text => "Pytanie 1", :poll => @poll, :question_type => "Otwarte")
    @q2 = create_question(:text => "Pytanie 2", :poll => @poll, :question_type => "Otwarte")
    @a1 = create_question_answer(:question => @q1, :value => "Odpowiedź 1")
    @a2 = create_question_answer(:question => @q1, :value => "Odpowiedź 2")
    @a1 = create_question_answer(:question => @q2, :value => "Odpowiedź 3")
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
end
