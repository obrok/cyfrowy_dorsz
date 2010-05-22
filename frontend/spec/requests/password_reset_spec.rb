require 'spec/spec_helper'

describe "Logged in user" do
  before(:each) do
    login
  end

  [["reset_password", :get],
   ["perform_reset_password", :post],
   ["request_reset_password", :get],
   ["send_reset_password", :post]
  ].each do |action, method|
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
    visit resource(:users, :reset_password, :token => @token)
    fill_in "Nowe hasło", :with => "nowe hasło"
    fill_in "Potwierdź", :with => "nowe hasło"
    click_button "Zapisz"
    response.should include "Hasło zmienione"

    login_as(@user, "nowe hasło")
    visit "/"
    response_status.should == 200
  end

  it "doesn't work if the confirmation is not the same" do
    pending
  end

  it "doesn't allow viewing of the reset form with an incorrect token" do
    visit resource(:users, :reset_password, :token => "not a token")
    response_status.should == 403
  end

  it "shows an error message on reset submission with wrong token" do
    pending
  end

  it "allows user to request a reset email" do
    pending
  end
end
