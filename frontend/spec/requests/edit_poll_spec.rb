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
end
