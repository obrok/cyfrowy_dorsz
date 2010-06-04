require 'spec/spec_helper'

describe "Creating the poll" do
  before(:each) do
    @user = create_user
    login_as(@user, CreationTestHelper::USER_HASH[:password])
  end

  after(:each) do
    logout
  end

  it "shows new poll form" do
    visit resource(:polls, :new)
    response.should include "Podaj nazwę nowej ankiety"
  end

  it "creates the poll correctly" do
    name = "#{Time.now.to_f}"
  
    visit resource(:polls, :new)
    fill_in "Nazwa", :with => name
    click_button "Stwórz"
    response.should include "Stworzono ankietę " + name
  end
end
