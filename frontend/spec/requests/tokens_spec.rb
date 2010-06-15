require 'spec/spec_helper'

describe Tokens do
  before(:each) do
    @user = create_user
    login_as(@user, CreationTestHelper::USER_HASH[:password])
  end

  it "should redirect to tokens list after tokens generation" do
    poll = create_poll(:user => @user)
    visit '/polls' / poll.id / 'edit'
    click_link 'Generuj tokeny'
    click_button 'Generuj tokeny'

    response.should include("Tokeny dla ankiety")
    response.should include(poll.name)
  end
end