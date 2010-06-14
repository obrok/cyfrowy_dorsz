require 'spec/spec_helper'

describe Answer do
  before(:each) do
    @answer = create_answer
  end

  after(:each) do
    @answer.destroy
  end

  it "should be valid" do
    @answer.should be_valid
  end

  [:date, :poll].each do |field|
    it "should validate presence of #{field}" do
      @answer.send("#{field}=", nil)
      @answer.should_not be_valid
    end
  end
end
