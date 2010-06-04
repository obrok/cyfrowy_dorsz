require 'spec/spec_helper'

describe Question do
  before(:each) do
    @question = create_question
  end

  after(:each) do
    @question.destroy
  end

  it "should be valid" do
    @question.should be_valid
  end

  [:text, :poll, :question_type].each do |field|
    it "should validate presence of #{field}" do
      @question.send("#{field}=", nil)
      @question.should_not be_valid
    end
  end

  it "should have valid question type" do
    @question.question_type = "invalid_type"
    @question.should_not be_valid
  end
end
