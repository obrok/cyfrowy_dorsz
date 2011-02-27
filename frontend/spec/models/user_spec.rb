require 'spec/spec_helper'

describe User do
  before(:each) do
    @user = create_user
    @poll = create_poll(:user => @user)
    question = create_question(:poll => @poll, :question_type => Question::TYPES[:closed])
    create_question_answer(:question => question, :value => 1)
    create_question_answer(:question => question, :value => 4)
  end

  after(:each) do
    @user.destroy
  end

  it "should be valid" do
    @user.should be_valid
  end

  it "should validate uniqueness of email" do
    user = User.new
    user.admin = false
    user.email = @user.email
    user.password = user.password_confirmation = "123"
    user.should_not be_valid
  end

  it "should validate email format" do
    @user.email = Time.now.to_f.to_s
    @user.should_not be_valid
  end

  [:email, :password, :password_confirmation, :admin].each do |field|
    it "should validate presence of #{field}" do
      @user.send("#{field}=", nil)
      @user.should_not be_valid
    end
  end

  it "should randomize the password" do
    @user.randomize_password!
    password = @user.password
    @user.randomize_password!
    password.should_not == @user.password
  end

  it "should prepare a login token" do
    @user.reset_password!
    @user.login_token.should_not be_nil
  end

  it "should notify the user" do
    @user.reset_password!
    last_email.to.should include @user.email
    last_email.text.should include @user.login_token
  end

  it "should count correct ranking" do
    @user.ranking.should == 2.5
  end

  it "shoud not count ranking for admin" do
    @user.admin = true
    @user.ranking.should be_nil
  end

  it "should provide information about user type" do
    @user.teacher?.should be_true
    @user.admin?.should be_false
    @user.admin = true
    @user.teacher?.should be_false
    @user.admin?.should be_true
  end
end
