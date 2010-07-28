# -*- coding: utf-8 -*-
require 'spec_helper'

describe Questions do
  before(:each) do
    @user = create_user
    login_as(@user, CreationTestHelper::USER_HASH[:password])
    @poll = create_poll(:user => @user)
    @question = create_question(:poll => @poll)
    @teacher_question = create_question(:poll => @poll, :question_type => Question::TYPES[:teacher])
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

      it "shows user info as possible answer in teacher choice question" do
        visit resource(@poll, @teacher_question, :edit)
        response.should include Question.user_to_teacher(@user)
      end
      
      it "should add user info as possible answer in teacher choice question" do
        user_info = Question.user_to_teacher(@user)

        visit resource(@poll, @teacher_question, :edit)
        select user_info, :from => "Nowy prowadzący"
        click_button "Dodaj odpowiedź"
        
        visit resource(@poll, @teacher_question, :edit)
        response.should include user_info
        lambda{select user_info, :from => "Nowy prowadzący"}.should raise_error
      end

      it "should allow question type changes" do
        visit resource(@poll, @question, :edit)
        Question::TYPES.values.select{|x| x != Question::TYPES[:teacher]}.each do |question|
          response.should include question
        end
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
