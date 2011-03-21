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

  it "should not be used after creation" do
    @token.remaining_count.should > 0
  end

  it "should have a unique value" do
    value = "#{Time.now.to_f}"
    tokenA = create_token(:value => value)
    lambda { create_token(:value => value) }.should raise_error Sequel::ValidationFailed
    tokenA.destroy
  end

  it "remaining count should be decreased after answering" do
    create_answer(:poll => @token.poll, :token => @token)
    @token.remaining_count.should == @token.max_usage - 1
  end

  it "should allow multiple answers" do
    @token.max_usage = 2
    answer = create_answer(:poll => @token.poll, :token => @token)
    @token.remaining_count.should > 0
    answer = create_answer(:poll => @token.poll, :token => @token)
    @token.remaining_count.should == 0
  end

  [:value, :poll, :valid_until, :max_usage].each do |field|
    it "should validate presence of #{field}" do
      @token.send("#{field}=", nil)
      @token.should_not be_valid
    end
  end

  it "should not be possible to create tokens for admin's poll" do
    admin = create_user(:admin => true)
    poll = create_poll(:user => admin)
    lambda { token = create_token(:poll => poll) }.should raise_error Sequel::ValidationFailed
  end
end
