require 'spec/spec_helper'

describe "Admin Panel" do
  before(:each) do
    login_as(create_user(:admin => true))
  end

  it "should not be accessible by teacher" do
    logout
    login
    visit resource(:users, :new)

    response_status.should == 403
  end

  it "should be accessible by admin" do
    visit resource(:users, :new)
    response_status.should == 200
  end
  
  it "should be linked to admins layout" do
    visit "/"
    response.should include "Administrator"
  end

  it "shows new user form" do
    visit resource(:users, :new)
    response.should include "Email prowadzącego"
  end

  it "should inform about incorrect email format" do
    visit resource(:users, :new)
    fill_in :email, :with => Time.now.to_f
    click_button "Stwórz"
    response.should include "Niepoprawny format"
  end

  it "should create user properly" do
    visit resource(:users, :new)
    name = "#{Time.now.to_f}@example.com"
    fill_in :email, :with => name
    click_button "Stwórz"
    response.should include "Konto zostało utworzone"
    last_email.to.should include name
  end
end

describe "Blocking users" do
  before(:each) do
    @user = create_user(:admin => false)

    login_as(create_user(:admin => true))
  end

  it "should allow admin to block users" do
    visit resource(@user, :block)
    logout
    login_as(@user)
    response_status.should == 403
  end

  it "should allow admin to unblock users" do
    user = create_user(:blocked => true)
    visit resource(user, :unblock)
    logout
    login_as(user)
    response_status.should == 200
  end
end

describe "Blocking polls" do
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

    login_as(create_user(:admin => true))
  end

  it "should not be accessible by teacher" do
    logout
    login
    visit resource(:users, :admin)

    response_status.should == 403
  end

  it "should be accessible by admin" do
    visit resource(:users, :admin)
    response_status.should == 200
  end

  it "should contain users' mails and polls" do
    visit resource(:users, :admin)
    response.should include @user.email
    response.should include @poll.name
  end

  it "should allow admin to block a poll" do
    token = create_token(:poll => @poll)
    visit resource(@poll, :block)

    logout
    visit "/"
    click_link "Student"

    fill_in "Token", :with => token.value
    click_button "Wypełnij ankietę"
    response.should_not include @poll.name
  end

  it "should not allow teacher to block a poll" do
    logout
    login_as(create_user(:admin => false))
    visit resource(@poll, :block)

    response_status.should == 403
  end

  it "should allow admin to unblock a poll" do
    token = create_token(:poll => @poll)
    visit resource(@poll, :block)

    logout
    visit "/"
    click_link "Student"

    fill_in "Token", :with => token.value
    click_button "Wypełnij ankietę"
    response.should_not include @poll.name

    login_as(create_user(:admin => true))
    visit resource(@poll, :unblock)

    logout
    visit "/"
    click_link "Student"

    fill_in "Token", :with => token.value
    click_button "Wypełnij ankietę"
    response.should include @poll.name
  end
end
