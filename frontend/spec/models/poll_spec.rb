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

  it "should update questions' positions properly" do
    questions = (1..3).map { |i| create_question(:poll => @poll, :position => i) }
    positions = {
      questions[2].id.to_s => '1',
      questions[0].id.to_s => '3'
    }
    @poll.update_questions_positions(positions)
    sorted_questions = @poll.questions_dataset.order(:position).map(&:id)
    sorted_questions.should == [questions[2].id, questions[1].id, questions[0].id]
  end
end
