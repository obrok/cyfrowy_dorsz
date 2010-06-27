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

  it "should show correct amount of valid tokens after tokens generation" do
    poll = create_poll(:user => @user)
    visit '/polls' / poll.id / 'edit'
    click_link 'Generuj tokeny'
    fill_in "Ilość tokenów", :with => 20
    valid_until = "2100-01-01"
    fill_in "Data ważności", :with => valid_until
    click_button 'Generuj tokeny'

    response.should include(valid_until)
    poll.tokens.size.should be_equal 20
    poll.tokens.each do |token|
      response.should include(token.value)
    end
  end
end
