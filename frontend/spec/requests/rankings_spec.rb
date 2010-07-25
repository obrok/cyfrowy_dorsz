require 'spec/spec_helper'

describe Rankings do
  before(:each) do
    @user = create_user
    poll = create_poll(:user => @user)
    question = create_question(:poll => poll, :question_type => Question::TYPES[:closed])
    create_question_answer(:question => question, :value => 1)
    create_question_answer(:question => question, :value => 4)

    @user2 = create_user
    poll2 = create_poll(:user => @user2)
    question2 = create_question(:poll => poll2, :question_type => Question::TYPES[:closed])
    create_question_answer(:question => question2, :value => 5)
    create_question_answer(:question => question2, :value => 4)
  end

  it "should contain user's e-mail" do
    visit '/rankings'

    response.should include(@user.email)
  end

  it "should contain user's ranking" do
    visit '/rankings'

    response.should include(@user.ranking.to_s)
  end

  it "should display users in correct order" do
    visit '/rankings'

    response.index(@user2.email).should < response.index(@user.email)
  end
end
