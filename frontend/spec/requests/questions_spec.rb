require 'spec_helper'

describe Questions do
  before(:each) do
    @user = create_user
    login_as(@user, CreationTestHelper::USER_HASH[:password])
    @poll = create_poll(:user => @user)
    @question = create_question(:poll => @poll)
  end

  describe "edit" do
    context "question has some answers" do
      it "should be forbidden" do
        create_question_answer(:question => @question)
        visit resource(@poll, @question, :edit)
        response_status.should == 403
      end
    end

    context "question has some answers" do
      it "should render edit properly" do
        visit resource(@poll, @question, :edit)
        response_status.should == 200
      end
    end
  end

  describe "delete" do
    context "question has some answers" do
      it "should be forbidden" do
        create_question_answer(:question => @question)
        visit resource(@poll, :edit)
        click_link 'usuń'
        response_status.should == 403
      end
    end

    context "question has some answers" do
      it "should render edit properly" do
        visit resource(@poll, :edit)
        click_link 'usuń'
        response_status.should == 200
      end
    end
  end
end