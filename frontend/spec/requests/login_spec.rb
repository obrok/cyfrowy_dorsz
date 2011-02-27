require 'spec/spec_helper'

describe "Logged in user" do
  before(:each) do
    login
    visit "/"
  end

  it "can access the main controller" do
    response_status.should == 200
  end
end

describe "Logged in teacher" do
  before(:each) do
    login
    visit resource(:admins, :tasks)
  end

  it "cannot access the admin controller" do
    response_status.should == 403
  end
end

describe "Logged in admin" do
  before(:each) do
    login_as(create_user(:admin => true))
  end

  it "can access the admin controller" do
    visit resource(:admins, :tasks)
    response_status.should == 200
  end

  it "should see link do administrators panel" do
    visit "/"
    response.should include "Administrator"
  end

end

describe "Not logged in user" do
  before(:each) do
    logout
    visit "/"
  end

  it "cannot access the main controller" do
    response_status.should == 401
  end

  it "should see the login form" do
    response.should include "Email"   
  end

  it "should have to provide correct data to login" do
    @user = create_user
    fill_in "Email", :with => @user.email
    click_button "Log In"
    response_status.should == 401
  end
end
