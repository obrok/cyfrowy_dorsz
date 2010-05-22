require 'spec/spec_helper'

describe UserMailer do
  before(:each) do
    @user = create_user
    @user.reset_password!
  end

  it "should contain an abosulte link" do
    last_email.text.should include "http://localhost:4000/users/reset_password?token=#{@user.login_token}"
  end
end
