require 'spec/spec_helper'

describe Token do
  before(:each) do
    @token = create_token
  end

  after(:each) do
    @token.destroy
  end

  it "should be valid" do
    @token.should be_valid
  end

  it "should be invalid if is a single token and has max usage > 1" do
    @token.max_usage = 10
    @token.token_type = Token::TYPES[:single]
    @token.should_not be_valid
  end

  it "should not be used after creation" do
    @token.used.should be_false
  end

  it "should have a unique value" do
    value = "#{Time.now.to_f}"
    tokenA = create_token(:value => value)
    lambda { create_token(:value => value) }.should raise_error Sequel::ValidationFailed
    tokenA.destroy
  end

  it "should be used after answering" do
    answer = create_answer(:poll => @token.poll, :token => @token)
    @token.used.should be_true
  end

  it "should allow multiple answers" do
    @token.max_usage = 2
    @token.token_type = Token::TYPES[:multi]
    answer = create_answer(:poll => @token.poll, :token => @token)
    @token.used.should be_false
    answer = create_answer(:poll => @token.poll, :token => @token)
    @token.used.should be_true
  end

  [:value, :poll, :valid_until, :token_type, :max_usage].each do |field|
    it "should validate presence of #{field}" do
      @token.send("#{field}=", nil)
      @token.should_not be_valid
    end
  end
end
