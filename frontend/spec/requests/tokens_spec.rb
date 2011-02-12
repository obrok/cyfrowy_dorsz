require 'spec/spec_helper'

describe Tokens do
  before(:each) do
    @user = create_user
    @poll = create_poll(:user => @user)
    login_as(@user, CreationTestHelper::USER_HASH[:password])
    visit resource(@poll, :edit)
  end

  it "should redirect to tokens list after tokens generation" do
    onetime_token
    response.should include("Tokeny dla ankiety")
    response.should include(@poll.name)
  end

  it "should show correct amount of valid tokens after single-tokens generation" do
    onetime_token
    response.should include(TokensTestHelper::ONETIME_TOKEN_HASH["Data ważności"])
    @poll.tokens.size.should be_equal TokensTestHelper::ONETIME_TOKEN_HASH["Ilość tokenów"]
    @poll.tokens.each do |token|
      response.should include(token.value)
    end
  end

  it "should show correct token after multi-token generation" do
    value = Time.now.to_f.to_s 
    reusable_token("Nazwa" => value)
    response.should include(TokensTestHelper::ONETIME_TOKEN_HASH["Data ważności"])
    response.should include(value)
  end

  it "should display print view correctly" do
    click_link 'Drukuj tokeny'
    response.should include('Tokeny dla ankiety')
    response.should include(@poll.name)
  end

  it "should warn user if token name was not unique" do
    value = Time.now.to_f.to_s
    reusable_token("Nazwa" => value)
    reusable_token("Nazwa" => value)

    response.should include('Podana nazwa nie jest już zajęta. Spróbuj ponownie')
    response.should include(@poll.name)
  end
end
