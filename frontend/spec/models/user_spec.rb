require 'spec/spec_helper'

describe User do
  before(:each) do
    @user = create_user
  end

  after(:each) do
    @user.destroy
  end

  it "should be valid" do
    @user.should be_valid
  end

  it "should validate uniqueness of email" do
    user = User.new
    user.email = @user.email
    user.password = user.password_confirmation = "123"
    user.should_not be_valid
  end

  [:email, :password, :password_confirmation].each do |field|
    it "should validate presence of #{field}" do
      @user.send("#{field}=", nil)
      @user.should_not be_valid
    end
  end
end
