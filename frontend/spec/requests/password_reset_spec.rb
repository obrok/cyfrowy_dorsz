require 'spec/spec_helper'

describe "Logged in user" do
  before(:each) do
    login
  end

  [["reset_password", :get],
   ["perform_reset_password", :post],
   ["request_reset_password", :get]].each do |action, method|
    it "cannot access the #{action} action" do
      visit "/users/#{action}", method
      response_status.should == 403
    end
  end
end

describe "Resetting the password" do
  before(:each) do
    logout
    User.destroy
    @token = "123"
    @user = create_user(:login_token => @token)
  end

  it "shows the reset form if the correct token is supplied" do
    visit resource(:users, :reset_password, :token => @token)
    response.should include "Zmiana hasła"
  end

  it "resets the password correctly" do
    pending
  end

  it "doesn't allow viewing of the reset form with an incorrect token" do
    pending
  end

  it "shows an error message on reset submission with wrong token" do
    pending
  end

  it "allows user to request a reset email" do
    pending
  end
end
