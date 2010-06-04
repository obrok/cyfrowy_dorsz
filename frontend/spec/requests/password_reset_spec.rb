require 'spec/spec_helper'

describe "Logged in user" do
  before(:each) do
    login
    Merb::Config[:disable_csrf] = true
  end

  after(:each) do
    Merb::Config[:disable_csrf] = false
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
    Merb::Config[:disable_csrf] = true
  end

  after(:each) do
    Merb::Config[:disable_csrf] = false
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
    visit resource(:users, :reset_password, :token => @token)
    fill_in "Nowe hasło", :with => "nowe hasło"
    fill_in "Potwierdź", :with => "inne hasło"
    click_button "Zapisz"
    response.should include "Hasła różnią się"
    response.should include "Zmiana hasła"
  end

  it "doesn't allow viewing of the reset form with an incorrect token" do
    visit resource(:users, :reset_password, :token => "not a token")
    response_status.should == 403
  end

  it "shows an error message on reset submission with wrong token" do
    visit resource(:users, :perform_reset_password, :token => "not a token", :password => "123", :password_confirmation => "123"), :post
    response_status.should == 403
  end

  it "allows user to request a reset email" do
    visit url(:login)
    click_link "Zapomniałem hasła"
    fill_in "Email", :with => @user.email
    click_button "Wyślij"

    response.should include "Wysłano email"
    last_email.to.should include @user.email
    last_email.text.should include @user.reload.login_token
  end
end
