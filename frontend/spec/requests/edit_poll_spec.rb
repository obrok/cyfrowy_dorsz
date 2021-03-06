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

  it "is possible to change poll name" do
    fill_in("Nazwa", :with => "Nowa nazwa")
    click_button("Zmień")
    @poll.reload.name.should == "Nowa nazwa"
  end
end

describe "Edit poll" do
  before(:each) do
    @user = create_user
    @poll = create_poll(:user => @user)
    login_as(@user, CreationTestHelper::USER_HASH[:password])
    visit(resource(@poll, :edit))
  end

  it "should be possible to hide poll" do
    visit(resource(@poll, :hide))
    response.should include "Pokaż ankietę."
  end

  it "should be possible to show poll" do
    @poll.visible = false
    visit(resource(@poll, :show))
    response.should include "Ukryj ankietę."
  end

  it "should not link to tokens in admin's poll" do
    admin = create_user(:admin => true)
    poll = create_poll(:user => admin)
    visit resource(poll, :edit)

    response.should_not include "tokeny"
  end 

  it "should not link to stats in admin's poll" do
    admin = create_user(:admin => true)
    poll = create_poll(:user => admin)
    visit resource(poll, :edit)

    response.should_not include "Statystyki"
  end 
end

describe "Poll with answers" do
  before(:each) do
    @poll = create_poll
    @user = @poll.user
    @q1 = create_question(:text => "Pytanie 1", :poll => @poll, :question_type => Question::TYPES[:open])

    @a1 = create_question_answer(:question => @q1, :value => "Odpowiedź 1")
    @a2 = create_question_answer(:question => @q1, :value => "Odpowiedź 2")

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

  it "should be possible to copy the poll" do
    click_button "Skopiuj ankietę"
    response.should include @poll.name + " Kopia"
    @poll.user.polls.size.should == 2
  end
end

