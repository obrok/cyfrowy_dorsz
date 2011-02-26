# -*- coding: utf-8 -*-
require 'spec/spec_helper'

describe "Profile" do
  before(:each) do
    @user = create_user(:password => "1234", :password_confirmation => "1234")
    login_as(@user, "1234")
    visit "/users/profile"
  end

  it "should enable the user to change his password" do
    fill_in("Stare hasło", :with => "1234")
    fill_in("Nowe hasło", :with => "12345")
    fill_in("Powtórz nowe hasło", :with => "12345")
    click_button "Zmień"

    logout
    login_as(@user, "1234")
    response_status.should == 401
    login_as(@user, "12345")
    response_status.should == 200
  end

  it "should not allow a change if the passwords don't match" do
    fill_in("Stare hasło", :with => "1234")
    fill_in("Nowe hasło", :with => "12345")
    fill_in("Powtórz nowe hasło", :with => "1234")
    click_button "Zmień"

    response.should include "Hasła różnią się"
    logout
    login_as(@user, "1234")
    response_status.should == 200
  end

  it "should not allow a change if old password is not provided" do
    fill_in("Stare hasło", :with => "12345")
    fill_in("Nowe hasło", :with => "12345")
    fill_in("Powtórz nowe hasło", :with => "12345")
    click_button "Zmień"

    response.should include "Niepoprawne hasło"
    logout
    login_as(@user, "12345")
    response_status.should == 401
  end
end
