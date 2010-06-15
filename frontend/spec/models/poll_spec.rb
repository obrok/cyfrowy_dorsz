require 'spec/spec_helper'

describe Poll do
  before(:each) do
    @poll = create_poll
  end

  after(:each) do
    @poll.destroy
  end

  it "should be valid" do
    @poll.should be_valid
  end

  it "should validate presence of name" do
    @poll.name = nil
    @poll.should_not be_valid
  end

  it "should validate poll type" do
    @poll.poll_type = 'something stupid'
    @poll.should_not be_valid
  end
end
