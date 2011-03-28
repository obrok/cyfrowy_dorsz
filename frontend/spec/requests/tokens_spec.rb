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
    visit resource(@poll, :edit)
    reusable_token("Nazwa" => value)

    response.should include("Nazwa musi być unikatowa")
    response.should include(@poll.name)
  end

  it "should inform about incorrect tokens count" do
    onetime_token("Ilość tokenów" => -5)

    response.should include("Niepoprawna wartość")
    response.should include(@poll.name)
  end

  it "should be forbidden to delete other users tokens" do
    token = create_token
    visit resource(@poll, token, :delete)

    response_status.should == 404
  end 

  it "should be possible to delete used token" do
    token = create_token(:poll => @poll, :max_usage => 10)
    question = create_question(:poll => @poll)

    answer = create_answer(:token => token)
    visit resource(@poll, :tokens)
    response.should include token.value
    click_link 'usuń'
    response.should include token.value
    response.should include "Nie można usunać użytego tokenu"
  end

  it "should not display used tokens" do
    token = create_token(:max_usage => 1, :poll => @poll)

    visit resource(@poll, :tokens)
    response.should include token.value

    ans = create_answer(:token => token)

    visit resource(@poll, :tokens)

    response.should_not include token.value
  end 
end
