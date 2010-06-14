require 'spec/spec_helper'

describe "Viewing list of polls" do
  before(:each) do
    @user = create_user
    login_as(@user, CreationTestHelper::USER_HASH[:password])
  end

  after(:each) do
    logout
  end

  it "shows user polls index" do
    visit resource(:polls)
    response.should include "Twoje ankiety"
  end

  it "should contain all user's polls" do
    name = "#{Time.now.to_f}"
  
    create_poll(:user => @user, :name => name + "A")
    create_poll(:user => @user, :name => name + "B")

    visit resource(:polls)
    response.should include name + "A"
    response.should include name + "B"
  end
end
