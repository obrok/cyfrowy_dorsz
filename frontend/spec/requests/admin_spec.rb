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
